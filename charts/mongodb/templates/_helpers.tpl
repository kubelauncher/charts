{{- define "mongodb.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "mongodb.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{- define "mongodb.namespace" -}}
{{- .Values.namespaceOverride | default .Release.Namespace }}
{{- end }}

{{- define "mongodb.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "mongodb.labels" -}}
helm.sh/chart: {{ include "mongodb.chart" . }}
{{ include "mongodb.selectorLabels" . }}
app.kubernetes.io/version: {{ .Values.image.tag | default .Chart.AppVersion | quote }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- with .Values.commonLabels }}
{{ toYaml . }}
{{- end }}
{{- end }}

{{- define "mongodb.selectorLabels" -}}
app.kubernetes.io/name: {{ include "mongodb.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{- define "mongodb.image" -}}
{{- $registry := .Values.global.imageRegistry | default .Values.image.registry -}}
{{- $repository := .Values.image.repository -}}
{{- $tag := .Values.image.tag | default .Chart.AppVersion -}}
{{- if .Values.image.digest }}
{{- printf "%s/%s@%s" $registry $repository .Values.image.digest }}
{{- else }}
{{- printf "%s/%s:%s" $registry $repository $tag }}
{{- end }}
{{- end }}

{{- define "mongodb.secretName" -}}
{{- if .Values.auth.existingSecret }}
{{- .Values.auth.existingSecret }}
{{- else }}
{{- include "mongodb.fullname" . }}
{{- end }}
{{- end }}

{{- define "mongodb.rootPasswordKey" -}}
{{- .Values.auth.secretKeys.rootPasswordKey | default "mongodb-root-password" }}
{{- end }}

{{- define "mongodb.userPasswordKey" -}}
{{- .Values.auth.secretKeys.userPasswordKey | default "mongodb-password" }}
{{- end }}

{{- define "mongodb.rootPassword" -}}
{{- if .Values.global.mongodb.auth.rootPassword }}
{{- .Values.global.mongodb.auth.rootPassword }}
{{- else }}
{{- .Values.auth.rootPassword | default (randAlphaNum 10) }}
{{- end }}
{{- end }}

{{- define "mongodb.rootUsername" -}}
{{- .Values.global.mongodb.auth.rootUsername | default .Values.auth.rootUsername | default "root" }}
{{- end }}

{{- define "mongodb.username" -}}
{{- .Values.global.mongodb.auth.username | default .Values.auth.username }}
{{- end }}

{{- define "mongodb.userPassword" -}}
{{- if .Values.global.mongodb.auth.password }}
{{- .Values.global.mongodb.auth.password }}
{{- else }}
{{- .Values.auth.password | default (randAlphaNum 10) }}
{{- end }}
{{- end }}

{{- define "mongodb.database" -}}
{{- .Values.global.mongodb.auth.database | default .Values.auth.database }}
{{- end }}

{{- define "mongodb.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "mongodb.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{- define "mongodb.servicePort" -}}
{{- .Values.global.mongodb.service.ports.mongodb | default .Values.primary.service.ports.mongodb }}
{{- end }}

{{- define "mongodb.replicaSetEnabled" -}}
{{- if eq .Values.architecture "replicaset" -}}true{{- end -}}
{{- end -}}

{{- define "mongodb.keyfileSecretName" -}}
{{- if .Values.replicaset.existingKeyfileSecret -}}
{{- .Values.replicaset.existingKeyfileSecret -}}
{{- else -}}
{{- printf "%s-keyfile" (include "mongodb.fullname" .) -}}
{{- end -}}
{{- end -}}

{{- define "mongodb.primaryHost" -}}
{{- printf "%s-0.%s-hl.%s.svc.%s" (include "mongodb.fullname" .) (include "mongodb.fullname" .) (include "mongodb.namespace" .) .Values.clusterDomain -}}
{{- end -}}

{{- define "mongodb.secondaryHosts" -}}
{{- $fullname := include "mongodb.fullname" . -}}
{{- $namespace := include "mongodb.namespace" . -}}
{{- $clusterDomain := .Values.clusterDomain -}}
{{- $replicaCount := int .Values.secondary.replicaCount -}}
{{- $hosts := list -}}
{{- range $i := until $replicaCount -}}
{{- $hosts = append $hosts (printf "%s-secondary-%d.%s-secondary-hl.%s.svc.%s" $fullname $i $fullname $namespace $clusterDomain) -}}
{{- end -}}
{{- join "," $hosts -}}
{{- end -}}

{{- define "mongodb.resources" -}}
{{- $preset := .preset -}}
{{- if eq $preset "nano" }}
requests:
  cpu: 100m
  memory: 128Mi
limits:
  cpu: 150m
  memory: 256Mi
{{- else if eq $preset "micro" }}
requests:
  cpu: 250m
  memory: 256Mi
limits:
  cpu: 500m
  memory: 512Mi
{{- else if eq $preset "small" }}
requests:
  cpu: 500m
  memory: 512Mi
limits:
  cpu: "1"
  memory: 1Gi
{{- end }}
{{- end }}
