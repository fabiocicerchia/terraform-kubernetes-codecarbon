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
      # TRIVY FINDING: hostNetwork=true - Cannot be fixed
      # Reason: Required for CodeCarbon to access host network interfaces for accurate energy measurements
      hostNetwork: true
      # TRIVY FINDING: hostPID=true - Cannot be fixed
      # Reason: Required for CodeCarbon to access process information for carbon attribution
      hostPID: true
      securityContext:
        seccompProfile:
          type: RuntimeDefault
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
          # TRIVY FINDING: privileged=true - Cannot be fixed
          # Reason: Required for CodeCarbon to access hardware sensors (CPU, GPU, RAM) for energy measurements
          privileged: true
          # TRIVY FINDING: allowPrivilegeEscalation=true - Cannot be fixed
          # Reason: Implied by privileged=true, necessary for hardware access
          allowPrivilegeEscalation: true
          # TRIVY FINDING: runAsNonRoot=false - Cannot be fixed
          # Reason: Root access required to read hardware sensors and system metrics
          runAsNonRoot: false
          capabilities:
            drop:
            - ALL
      volumes:
      # TRIVY FINDING: hostPath volumes - Cannot be fixed
      # Reason: CodeCarbon requires direct access to /proc and /sys for reading system metrics and hardware sensors
      - name: host-proc
        hostPath:
          path: /proc
          type: Directory
      - name: host-sys
        hostPath:
          path: /sys
          type: Directory
