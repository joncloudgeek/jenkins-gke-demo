#!/bin/bash
gcloud compute ssh jenkins \
    --project devops-malaysia-jenkins-gke \
    --zone us-central1-a \
    -- -L 8080:localhost:8080
