{{- define "mysql.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "mysql.fullname" -}}
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

{{- define "mysql.namespace" -}}
{{- .Values.namespaceOverride | default .Release.Namespace }}
{{- end }}

{{- define "mysql.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "mysql.labels" -}}
helm.sh/chart: {{ include "mysql.chart" . }}
{{ include "mysql.selectorLabels" . }}
app.kubernetes.io/version: {{ .Values.image.tag | default .Chart.AppVersion | quote }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- with .Values.commonLabels }}
{{ toYaml . }}
{{- end }}
{{- end }}

{{- define "mysql.selectorLabels" -}}
app.kubernetes.io/name: {{ include "mysql.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{- define "mysql.image" -}}
{{- $registry := .Values.global.imageRegistry | default .Values.image.registry -}}
{{- $repository := .Values.image.repository -}}
{{- $tag := .Values.image.tag | default .Chart.AppVersion -}}
{{- if .Values.image.digest }}
{{- printf "%s/%s@%s" $registry $repository .Values.image.digest }}
{{- else }}
{{- printf "%s/%s:%s" $registry $repository $tag }}
{{- end }}
{{- end }}

{{- define "mysql.secretName" -}}
{{- if .Values.auth.existingSecret }}
{{- .Values.auth.existingSecret }}
{{- else }}
{{- include "mysql.fullname" . }}
{{- end }}
{{- end }}

{{- define "mysql.rootPasswordKey" -}}
{{- .Values.auth.secretKeys.rootPasswordKey | default "mysql-root-password" }}
{{- end }}

{{- define "mysql.userPasswordKey" -}}
{{- .Values.auth.secretKeys.userPasswordKey | default "mysql-password" }}
{{- end }}

{{- define "mysql.rootPassword" -}}
{{- if .Values.global.mysql.auth.rootPassword }}
{{- .Values.global.mysql.auth.rootPassword }}
{{- else }}
{{- .Values.auth.rootPassword | default (randAlphaNum 10) }}
{{- end }}
{{- end }}

{{- define "mysql.username" -}}
{{- .Values.global.mysql.auth.username | default .Values.auth.username }}
{{- end }}

{{- define "mysql.userPassword" -}}
{{- if .Values.global.mysql.auth.password }}
{{- .Values.global.mysql.auth.password }}
{{- else }}
{{- .Values.auth.password | default (randAlphaNum 10) }}
{{- end }}
{{- end }}

{{- define "mysql.database" -}}
{{- .Values.global.mysql.auth.database | default .Values.auth.database }}
{{- end }}

{{- define "mysql.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "mysql.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{- define "mysql.servicePort" -}}
{{- .Values.global.mysql.service.ports.mysql | default .Values.primary.service.ports.mysql }}
{{- end }}

{{- define "mysql.resources" -}}
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
