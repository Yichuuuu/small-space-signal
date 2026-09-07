---
title: "Guides by category"
layout: archive
permalink: /categories/
author_profile: false
---

Browse practical guides by the part of home life you want to improve.

{% assign guide_categories = site.guides | map: 'categories' | join: '|' | split: '|' | uniq | sort_natural %}

<ul class="taxonomy__index">
  {% for category in guide_categories %}
    {% assign category_guides = site.guides | where_exp: 'guide', 'guide.categories contains category' %}
    <li><a href="#{{ category | slugify }}"><strong>{{ category | escape }}</strong> <span class="taxonomy__count">{{ category_guides.size }}</span></a></li>
  {% endfor %}
</ul>

{% for category in guide_categories %}
  {% assign category_guides = site.guides | where_exp: 'guide', 'guide.categories contains category' | sort: 'title' %}
  <section id="{{ category | slugify }}" class="taxonomy__section">
    <h2 class="archive__subtitle">{{ category | escape }}</h2>
    <div class="entries-list">
      {% for post in category_guides %}
        {% include archive-single.html type='list' %}
      {% endfor %}
    </div>
    <a href="#page-title" class="back-to-top">Back to Top &uarr;</a>
  </section>
{% endfor %}
