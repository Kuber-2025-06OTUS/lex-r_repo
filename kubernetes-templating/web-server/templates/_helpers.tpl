{{- define "usedNamespace" -}}
{{- if .Values.namespace.create }}
{{- .Values.namespace.name }}
{{- else }}
{{- .Release.Namespace }}
{{- end }}
{{- end }}
