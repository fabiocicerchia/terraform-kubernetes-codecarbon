apiVersion: v1
kind: Namespace
metadata:
  name: ${namespace}
  labels:
    app.kubernetes.io/managed-by: terraform
---
apiVersion: apps/v1
kind: DaemonSet
metadata:
  name: ${name}
  namespace: ${namespace}
  labels:
    app.kubernetes.io/name: codecarbon
    app.kubernetes.io/instance: ${name}
spec:
  selector:
    matchLabels:
      app.kubernetes.io/name: codecarbon
      app.kubernetes.io/instance: ${name}
  template:
    metadata:
      labels:
        app.kubernetes.io/name: codecarbon
        app.kubernetes.io/instance: ${name}
    spec:
      hostNetwork: true
      hostPID: true
      tolerations:
      - effect: NoSchedule
        operator: Exists
      containers:
      - name: codecarbon
        image: ${image}
        command:
        - codecarbon
        - monitor
        env:
        - name: CODECARBON_API_URL
          value: "${api_url}"
%{ if experiment_id != "" ~}
        - name: CODECARBON_EXPERIMENT_ID
          value: "${experiment_id}"
%{ endif ~}
%{ if api_key != "" ~}
        - name: CODECARBON_API_KEY
          value: "${api_key}"
%{ endif ~}
%{ for key, value in extra_env ~}
        - name: ${key}
          value: "${value}"
%{ endfor ~}
        resources:
          requests:
            cpu: ${resources_requests_cpu}
            memory: ${resources_requests_memory}
          limits:
            cpu: ${resources_limits_cpu}
            memory: ${resources_limits_memory}
        volumeMounts:
        - name: host-proc
          mountPath: /host/proc
          readOnly: true
        - name: host-sys
          mountPath: /host/sys
          readOnly: true
        securityContext:
          privileged: true
      volumes:
      - name: host-proc
        hostPath:
          path: /proc
          type: Directory
      - name: host-sys
        hostPath:
          path: /sys
          type: Directory
