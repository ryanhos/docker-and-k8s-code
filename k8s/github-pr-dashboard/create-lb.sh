#!/usr/bin/env bash

if [ -z "${1}" ]; then
	echo "Please pass the GKE Instance name as the sole argument."
	exit 1
fi

if [ -z "${REGION}" ]; then
    REGION=us-central1
fi

ZONE=${REGION}-a
USER_SLUG=${USER//_/-}
INSTANCE_NAME=${1}
DNS_ZONE=ryanh-org

gcloud compute --project=${GOOGLE_CLOUD_PROJECT} addresses create $USER_SLUG --region=${REGION}

#gcloud compute target-pools create ${USER_SLUG}-github-pr-target-pool --region=${REGION} --http-health-check=k8s-a610d4e71d1dcc4e-node
gcloud compute target-pools create ${USER_SLUG}-github-pr-target-pool --region=${REGION}

gcloud compute target-pools add-instances ${USER_SLUG}-github-pr-target-pool --region=${REGION} --instances=${INSTANCE_NAME}  --instances-zone=${ZONE}

gcloud compute forwarding-rules create ${USER_SLUG}-forwarding-rule80 --address $USER_SLUG --ports=80 --target-pool=${USER_SLUG}-github-pr-target-pool --target-pool-region=${REGION} --region=${REGION}
gcloud compute forwarding-rules create ${USER_SLUG}-forwarding-rule443 --address $USER_SLUG --ports=443 --target-pool=${USER_SLUG}-github-pr-target-pool --target-pool-region=${REGION} --region=${REGION}

# Allow health checks to nginx ingress health port
#gcloud compute firewall-rules create allow-health-check \
#    --network default \
#    --source-ranges 209.85.152.0/22,209.85.204.0/22,35.191.0.0/16 \
#    --allow tcp:10254

MY_IP=$(gcloud compute addresses describe ${USER_SLUG} --project=${GOOGLE_CLOUD_PROJECT} --format='value(address)' --region=${REGION})

gcloud dns --project=${GOOGLE_CLOUD_PROJECT} record-sets transaction start --zone=${DNS_ZONE}
gcloud dns --project=${GOOGLE_CLOUD_PROJECT} record-sets transaction add ${MY_IP} --name=${USER_SLUG}.ryanh.org. --ttl=300 --type=A --zone=${DNS_ZONE}
gcloud dns --project=${GOOGLE_CLOUD_PROJECT} record-sets transaction execute --zone=${DNS_ZONE}

echo "Your IP is: ${MY_IP}"
echo "Your LB address is: http://${USER_SLUG}.ryanh.org"
