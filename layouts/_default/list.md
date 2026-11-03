{{- $summary := (.Params.description | default (.Params.summary | default (.Summary | plainify | htmlUnescape))) | replaceRE "\\s+" " " -}}
---
title: {{ .Title | plainify | htmlUnescape | jsonify }}
{{- with $summary }}
description: {{ . | jsonify }}
{{- end }}
language: {{ .Language.LanguageCode | jsonify }}
{{- with .Translations }}
translations:
{{- range . }}
  - lang: {{ .Language.LanguageCode | jsonify }}
    url: {{ .Permalink }}
    markdown_url: {{ .Permalink }}index.md
{{- end }}
{{- end }}
url: {{ .Permalink }}
---

# {{ .Title | plainify | htmlUnescape }}

> For the complete documentation index, see [llms.txt]({{ "llms.txt" | absLangURL }}) or the full site corpus at [llms-full.txt]({{ "llms-full.txt" | absLangURL }}).

- **URL**: {{ .Permalink }}
- **Markdown URL**: {{ .Permalink }}index.md
- **Author**: {{ .Site.Params.Author.name | default "Daniela Petruzalek" }}
{{- with .Translations }}
- **Translations**: {{ range $i, $t := . }}{{ if $i }}, {{ end }}[{{ $t.Language.LanguageName }} ({{ $t.Language.LanguageCode }})]({{ $t.Permalink }}index.md) ([HTML]({{ $t.Permalink }})){{ end }}
{{- end }}
{{- with $summary }}
- **Summary**: {{ . }}
{{- end }}

---
{{- with .RawContent }}

{{ . }}
{{- end }}

{{- if or (eq .Section "events") (eq .Section "talks") }}
{{- $allEvents := slice }}
{{- range .Site.Data.talks.talks }}
  {{- if .date }}
    {{- $allEvents = $allEvents | append . }}
  {{- end }}
{{- end }}
{{- $sortedEvents := sort $allEvents "date" "desc" }}

## Conference Talks, Keynotes & Workshops ({{ len $sortedEvents }})

{{- range $e := $sortedEvents }}
{{- $primaryUrl := $e.recording | default ($e.slides | default ($e.codelab | default ($e.materials | default ($e.source_code | default $e.url)))) }}
### {{ if $primaryUrl }}[{{ $e.title | plainify | htmlUnescape }}]({{ $primaryUrl | absURL }}){{ else }}{{ $e.title | plainify | htmlUnescape }}{{ end }}

- **Date**: {{ $e.date }}
{{- with $e.event }}
- **Event**: {{ if $e.url }}[{{ . | plainify | htmlUnescape }}]({{ $e.url | absURL }}){{ else }}{{ . | plainify | htmlUnescape }}{{ end }}
{{- end }}
{{- if and $e.location (ne $e.location "-") }}
- **Location**: {{ $e.location }}
{{- end }}
{{- with $e.language }}
- **Language**: {{ upper . }}
{{- end }}
{{- if or $e.recording $e.slides $e.codelab $e.materials $e.source_code }}
- **Resources**:{{ with $e.recording }} [Recording]({{ . | absURL }}){{ end }}{{ with $e.slides }} · [Slides]({{ . | absURL }}){{ end }}{{ with $e.codelab }} · [Codelab]({{ . | absURL }}){{ end }}{{ with $e.materials }} · [Materials]({{ . | absURL }}){{ end }}{{ with $e.source_code }} · [Source Code]({{ . | absURL }}){{ end }}
{{- end }}
{{- with $e.summary }}

{{ . | plainify | htmlUnescape }}
{{- end }}

{{ end }}

{{- else if eq .Section "videos" }}
{{- $channel := .Site.Data.videos.channel }}
{{- $sortedVideos := sort .Site.Data.videos.videos "date" "desc" }}

## YouTube Channel: [{{ $channel.handle }}]({{ $channel.url }})

{{ i18n "videos_channel_desc" | default $channel.description | plainify | htmlUnescape }}

- **Subscribe**: [YouTube Channel]({{ $channel.subscribeUrl }})
- **Talks Playlist**: [Full Playlist]({{ $channel.playlistUrl }})

## Videos & Screencasts ({{ len $sortedVideos }})

{{- range $v := $sortedVideos }}
### [{{ $v.title | plainify | htmlUnescape }}]({{ $v.url }})

- **Date**: {{ $v.date }}
{{- with $v.duration }}
- **Duration**: {{ . }}
{{- end }}
{{- with ($v.event | default $v.channelName) }}
- **Channel / Event**: {{ . | plainify | htmlUnescape }}
{{- end }}
{{- with $v.language }}
- **Language**: {{ upper . }}
{{- end }}
{{- if or $v.url $v.episode_url $v.post $v.slides $v.source_code }}
- **Links**: [Watch Video]({{ $v.url }}){{ with $v.episode_url }} · [Podcast]({{ . }}){{ end }}{{ with $v.post }} · [Companion Article]({{ printf "%sindex.md" (. | absURL) }}){{ end }}{{ with $v.slides }} · [Slides]({{ . }}){{ end }}{{ with $v.source_code }} · [Source Code]({{ . }}){{ end }}
{{- end }}
{{- with $v.summary }}

{{ . | plainify | htmlUnescape }}
{{- end }}

{{ end }}

{{- else if eq .Section "codelabs" }}

## Interactive Codelabs & Workshops ({{ len .Pages }})

{{- range .Pages.ByDate.Reverse }}
{{- $extUrl := .Params.externalUrl }}
### {{ if $extUrl }}[{{ .Title | plainify | htmlUnescape }}]({{ $extUrl }}){{ else if .Permalink }}[{{ .Title | plainify | htmlUnescape }}]({{ .Permalink }}index.md){{ else }}{{ .Title | plainify | htmlUnescape }}{{ end }}

- **Date**: {{ .Date.Format "2006-01-02" }}
{{- with .Permalink }}
- **Markdown Summary**: [{{ . }}index.md]({{ . }}index.md)
{{- end }}
{{- with $extUrl }}
- **Interactive Codelab URL**: [{{ . }}]({{ . }})
{{- end }}
{{- with .Params.proficiencyLevel }}
- **Level**: {{ . }}
{{- end }}
{{- with .Params.dependencies }}
- **Stack**: {{ delimit . ", " }}
{{- end }}
{{- with (.Params.description | default (.Summary | plainify | htmlUnescape)) }}

{{ . | replaceRE "\\s+" " " | plainify | htmlUnescape }}
{{- end }}

{{ end }}

{{- else }}

## Articles ({{ len .Pages }})

{{- range .Pages.ByDate.Reverse }}
{{- $seriesOrder := .Params.series_order }}
- **[{{ .Title | plainify | htmlUnescape }}]({{ .Permalink }}index.md)** ([HTML]({{ .Permalink }}) · {{ .Date.Format "2006-01-02" }}{{ with .Params.categories }} · Category: {{ delimit . ", " }}{{ end }}{{ with .Params.series }} · Series: {{ index . 0 }}{{ with $seriesOrder }} #{{ . }}{{ end }}{{ end }}{{ with .Params.tags }} · Tags: {{ delimit . ", " }}{{ end }}){{ with (.Params.description | default (.Summary | plainify | htmlUnescape)) }}: {{ . | replaceRE "\\s+" " " | plainify | htmlUnescape }}{{ end }}
{{- end }}
{{- end }}
