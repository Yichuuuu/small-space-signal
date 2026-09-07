---
title: "Guides by topic"
layout: archive
permalink: /tags/
author_profile: false
---

Find a guide for a specific room, storage challenge, or renter-friendly idea.

{% assign guide_topics = site.guides | map: 'tags' | join: '|' | split: '|' | uniq | sort_natural %}

<ul class="taxonomy__index">
  {% for topic in guide_topics %}
    {% assign topic_guides = site.guides | where_exp: 'guide', 'guide.tags contains topic' %}
    <li><a href="#{{ topic | slugify }}"><strong>{{ topic | escape }}</strong> <span class="taxonomy__count">{{ topic_guides.size }}</span></a></li>
  {% endfor %}
</ul>

{% for topic in guide_topics %}
  {% assign topic_guides = site.guides | where_exp: 'guide', 'guide.tags contains topic' | sort: 'title' %}
  <section id="{{ topic | slugify }}" class="taxonomy__section">
    <h2 class="archive__subtitle">{{ topic | escape }}</h2>
    <div class="entries-list">
      {% for post in topic_guides %}
        {% include archive-single.html type='list' %}
      {% endfor %}
    </div>
    <a href="#page-title" class="back-to-top">Back to Top &uarr;</a>
  </section>
{% endfor %}
