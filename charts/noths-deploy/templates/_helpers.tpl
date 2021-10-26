{{/*
Expand the name of the chart.
*/}}
{{- define "eks-deploy.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "eks-deploy.fullname" -}}
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

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "eks-deploy.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "eks-deploy.labels" -}}
helm.sh/chart: {{ include "eks-deploy.chart" . }}
{{ include "eks-deploy.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "eks-deploy.selectorLabels" -}}
app.kubernetes.io/name: {{ include "eks-deploy.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "eks-deploy.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "eks-deploy.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Create the name of the security group
*/}}
{{- define "eks-deploy.securityGroupName" -}}
{{- if .Values.securityGroup.create }}
{{- default (include "eks-deploy.fullname" .) .Values.securityGroup.name }}
{{- else }}
{{- default "default" .Values.securityGroup.name }}
{{- end }}
{{- end }}


{{/*
Defines a "function" converting a backend service address into a URL
*/}}
{{- define "backendUrl" -}}
{{- $backendAddress := get . "backendAddress" -}}
{{- $namespace := get . "namespace" -}}
{{- printf "http://%s.%s.svc.cluster.local/" $backendAddress $namespace -}}
{{- end -}}

{{/*
Return instance and name labels.
*/}}
{{- define "eks-deploy.instance-name" -}}
app.kubernetes.io/instance: {{ .Release.Name | quote }}
app.kubernetes.io/name: {{ include "eks-deploy.name" . | quote }}
{{- end -}}
