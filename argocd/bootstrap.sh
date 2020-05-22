#!/bin/bash

echo "Bootstrapping projects from the ./projects/ dir"
for f in ./projects/*; do
    echo "bootstrapping $f"
    cat <<EOF | kubectl apply -f -
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: $p
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
