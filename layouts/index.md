{{- $author := .Site.Data.identity.author -}}
{{- $summary := (.Site.Params.description | default .Site.Params.Author.headline) | plainify | htmlUnescape -}}
---
title: {{ .Site.Title | plainify | htmlUnescape | jsonify }}
description: {{ $summary | jsonify }}
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

# {{ .Site.Title | plainify | htmlUnescape }} — {{ $author.name | default "Daniela Petruzalek" }}

> For the complete documentation index, see [llms.txt]({{ "llms.txt" | absLangURL }}) or the full site corpus at [llms-full.txt]({{ "llms-full.txt" | absLangURL }}).

{{ .Site.Params.Author.bio | default "Senior Developer Relations Engineer at Google" | plainify | htmlUnescape }} — {{ i18n "homepage_tagline" | default "Writing about AI agents, Go, and Cloud." | plainify | htmlUnescape }}

- **Website**: {{ .Permalink }}
- **Markdown URL**: {{ .Permalink }}index.md
- **LLMs Index**: {{ "llms.txt" | absLangURL }}
- **LLMs Full Corpus**: {{ "llms-full.txt" | absLangURL }}
- **Agent Skills Catalog**: https://skills.danicat.dev/ ([llms.txt](https://skills.danicat.dev/llms.txt) · [Discovery Index](https://skills.danicat.dev/.well-known/agent-skills/index.json))
{{- with .Translations }}
- **Translations**: {{ range $i, $t := . }}{{ if $i }}, {{ end }}[{{ $t.Language.LanguageName }} ({{ $t.Language.LanguageCode }})]({{ $t.Permalink }}index.md) ([HTML]({{ $t.Permalink }})){{ end }}
{{- end }}

## Primary Sections

- [Posts & Technical Articles]({{ "posts/index.md" | absLangURL }}) ([HTML]({{ "posts/" | absLangURL }}))
- [Interactive Codelabs & Workshops]({{ "codelabs/index.md" | absLangURL }}) ([HTML]({{ "codelabs/" | absLangURL }}))
- [Speaking & Conference Events]({{ "events/index.md" | absLangURL }}) ([HTML]({{ "events/" | absLangURL }}))
- [Videos & Screencasts]({{ "videos/index.md" | absLangURL }}) ([HTML]({{ "videos/" | absLangURL }}))
- [About {{ $author.name | default "Daniela Petruzalek" }}]({{ "about/index.md" | absLangURL }}) ([HTML]({{ "about/" | absLangURL }}))

{{- $all_posts_sorted := (where .Site.RegularPages "Type" "posts").ByDate.Reverse -}}
{{- if gt (len $all_posts_sorted) 0 }}
{{- $latest_post := index $all_posts_sorted 0 }}

## Featured Article

- **[{{ $latest_post.Title | plainify | htmlUnescape }}]({{ $latest_post.Permalink }}index.md)** ([HTML]({{ $latest_post.Permalink }}) · {{ $latest_post.Date.Format "2006-01-02" }}{{ with $latest_post.Params.categories }} · {{ delimit . ", " }}{{ end }}){{ with ($latest_post.Params.description | default ($latest_post.Summary | plainify | htmlUnescape)) }}: {{ . | replaceRE "\\s+" " " | plainify | htmlUnescape }}{{ end }}
{{- end }}

{{- $now := now.Format "2006-01-02" -}}
{{- $upcomingEvents := slice -}}
{{- range .Site.Data.talks.talks }}
  {{- if and .date (ge .date $now) }}
    {{- $upcomingEvents = $upcomingEvents | append . }}
  {{- end }}
{{- end }}
{{- if gt (len $upcomingEvents) 0 }}

## {{ i18n "next_events_title" | default "My Next Events" }}

{{- range first 2 (sort $upcomingEvents "date" "asc") }}
- **[{{ .title | plainify | htmlUnescape }}]({{ .url | default ("events/index.md" | absLangURL) }})** — {{ .event | plainify | htmlUnescape }} ({{ .date }}{{ with .location }}, {{ . }}{{ end }}){{ with .summary }}: {{ . | replaceRE "\\s+" " " | plainify | htmlUnescape }}{{ end }}
{{- end }}
- [{{ i18n "view_all_events" | default "View All Events" }}]({{ "events/index.md" | absLangURL }})
{{- end }}

{{- $showRecentItems := .Site.Params.homepage.showRecentItems | default 6 -}}
{{- $recent_posts_list := after 1 $all_posts_sorted | first $showRecentItems -}}
{{- if gt (len $recent_posts_list) 0 }}

## {{ i18n "recent_posts" | default "Recent Posts" }}

{{- range $recent_posts_list }}
- **[{{ .Title | plainify | htmlUnescape }}]({{ .Permalink }}index.md)** ([HTML]({{ .Permalink }}) · {{ .Date.Format "2006-01-02" }}{{ with .Params.categories }} · {{ delimit . ", " }}{{ end }}{{ with .Params.tags }} · Tags: {{ delimit . ", " }}{{ end }}){{ with (.Params.description | default (.Summary | plainify | htmlUnescape)) }}: {{ . | replaceRE "\\s+" " " | plainify | htmlUnescape }}{{ end }}
{{- end }}

- [All Posts]({{ "posts/index.md" | absLangURL }})
{{- end }}
