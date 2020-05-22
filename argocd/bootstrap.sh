#!/bin/bash

echo "INFO: Bootstrapping all projects from the ./projects/ dir"
for f in ./projects/*; do

    PROJECT_NAME=$(basename $f .yaml)
    echo "bootstrapping project '$PROJECT_NAME' from file $f"
    cat <<EOF | kubectl apply -f -
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: $PROJECT_NAME
  namespace: argocd
spec:
  project: default
  destination:
    server: https://kubernetes.default.svc
    namespace: argocd
  syncPolicy:
    automated:
      prune: true
      selfHeal: true
    syncOptions:
    - Validate=true
  source:
    repoURL: https://github.com/musabmasood/gitops-main.git
    targetRevision: HEAD
    path: argocd/helm-bootstrap-projects
    helm:
      valueFiles:
      - ../$f
EOF
done
