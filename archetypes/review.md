---
title: "{{ replace .Name "-" " " | title }}" # Title of the blog post.
date: {{ .Date }} # Date of post creation.
featured: true # Sets if post is a featured post, making appear on the home page side bar.
thumbnail: "/images/path/thumbnail.png" # Sets thumbnail image appearing inside card on homepage.
categories:
- soda
- water
- kombucha
- other
rating:
- pass
- ok
- recomended
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

{{< figure src="/images/path/thumbnail.png" >}}