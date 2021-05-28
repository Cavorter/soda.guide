---
title: "{{ replace .Name "-" " " | title }}" # Title of the blog post.
date: {{ .Date }} # Date of post creation.
featured: false # Sets if post is a featured post, making appear on the home page side bar.
thumbnail: "{{ .Site.Params.image_root }}/review/thumbs/{{ .Name }}.jpg" # Sets thumbnail image appearing inside card on homepage.
categories:
- soda
- water
- kombucha
- other
ratings:
- pass
- ok
- Recommended
tags:
- Not Sweet
- Slightly Sweet
- Medium Sweet
- Quite Sweet
- Very Sweet
- SUGARBOMB
brands:
- brand1
---

**Review text here**

[Purchased from xxx](https://some.site)

{{< figure src="{{ .Site.Params.image_root }}/review/{{ .Name }}.jpg" >}}