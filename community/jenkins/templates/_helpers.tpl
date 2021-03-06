{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "jenkins.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "jenkins.fullname" -}}
{{- if .Values.fullnameOverride -}}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- if contains $name .Release.Name -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{- define "jenkins.kubernetes-version" -}}
  {{- range .Values.master.installPlugins -}}
    {{ if hasPrefix "kubernetes:" . }}
      {{- $split := splitList ":" . }}
      {{- printf "%s" (index $split 1 ) -}}
    {{- end -}}
  {{- end -}}
{{- end -}}

{{/*
Generate private key for jenkins CLI
*/}}
{{- define "jenkins.gen-key" -}}
{{- if not .Values.master.adminSshKey -}}
{{- $key := genPrivateKey "rsa" -}}
jenkins-admin-private-key: {{ $key | b64enc | quote }}
{{- end -}}
{{- end -}}

{{/*
Create the name of the service account to use
*/}}
{{- define "jenkins.serviceAccountName" -}}
{{- if .Values.serviceAccount.create -}}
    {{ default (include "jenkins.fullname" .) .Values.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{/*
  Secret name for jenkins admin user and password
*/}}
{{- define "jenkins.getsecret" -}}
{{- if not .Values.master.existingSecret -}}
{{ template "jenkins.fullname" . }}
{{- else -}}
{{- .Values.master.existingSecret -}}
{{- end -}}
{{- end -}}
