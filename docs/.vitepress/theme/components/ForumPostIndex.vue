<script setup lang="ts">
import { computed, ref } from "vue";
import type { TopicPost } from "../../../topics/posts.data";

const props = defineProps<{
  posts: TopicPost[];
}>();

const activeTag = ref("全部");

const formatDate = (value: string) => {
  const date = new Date(value);
  if (Number.isNaN(date.getTime())) {
    return value;
  }

  return new Intl.DateTimeFormat("zh-CN", {
    year: "numeric",
    month: "2-digit",
    day: "2-digit"
  }).format(date);
};

const availableTags = computed(() => {
  const values = new Set<string>();

  props.posts.forEach((post) => {
    post.tags.forEach((tag) => values.add(tag));
  });

  return ["全部", ...Array.from(values)];
});

const filteredPosts = computed(() => {
  if (activeTag.value === "全部") {
    return props.posts;
  }

  return props.posts.filter((post) => post.tags.includes(activeTag.value));
});

const groupedPosts = computed(() => {
  const groups = new Map<string, TopicPost[]>();

  filteredPosts.value.forEach((post) => {
    const current = groups.get(post.category) ?? [];
    current.push(post);
    groups.set(post.category, current);
  });

  return Array.from(groups.entries()).map(([category, posts]) => ({
    category,
    posts
  }));
});

const archivedPosts = computed(() => {
  const groups = new Map<string, TopicPost[]>();

  filteredPosts.value.forEach((post) => {
    const date = new Date(post.publishAt);
    const year = Number.isNaN(date.getTime()) ? "未知" : String(date.getFullYear());
    const current = groups.get(year) ?? [];
    current.push(post);
    groups.set(year, current);
  });

  return Array.from(groups.entries())
    .sort((left, right) => right[0].localeCompare(left[0]))
    .map(([year, posts]) => ({
      year,
      posts
    }));
});

const setActiveTag = (tag: string) => {
  activeTag.value = tag;
};
</script>

<template>
  <div class="forum-index">
    <section class="forum-section forum-section--compact">
      <div class="forum-section__head">
        <h2>按标签筛选</h2>
      </div>
      <div class="forum-topic-chips">
        <button
          v-for="tag in availableTags"
          :key="tag"
          type="button"
          class="forum-topic-chip"
          :class="{ 'is-active': activeTag === tag }"
          @click="setActiveTag(tag)"
        >
          {{ tag }}
        </button>
      </div>
    </section>

    <section class="forum-section">
      <div class="forum-section__head">
        <h2>最近更新</h2>
      </div>
      <div class="forum-post-grid">
        <a
          v-for="post in filteredPosts"
          :key="post.url"
          class="forum-post-card"
          :href="post.url"
        >
          <div class="forum-post-card__meta">
            <span class="forum-post-card__category">{{ post.category }}</span>
            <span class="forum-post-card__date">发布 {{ formatDate(post.publishAt) }}</span>
            <span class="forum-post-card__date">更新 {{ formatDate(post.updatedAt) }}</span>
          </div>
          <h3>{{ post.title }}</h3>
          <p class="forum-post-card__summary">{{ post.summary }}</p>
          <p class="forum-post-card__direction">
            <strong>阅读方向：</strong>{{ post.readingDirection }}
          </p>
          <div class="forum-post-card__tags">
            <span v-for="tag in post.tags" :key="tag">{{ tag }}</span>
          </div>
        </a>
      </div>
      <p v-if="!filteredPosts.length" class="forum-empty-state">当前标签下还没有文章。</p>
    </section>

    <section class="forum-section">
      <div class="forum-section__head">
        <h2>按主题分类</h2>
        <p>按问题域归拢，而不是按传统专题策展方式组织。</p>
      </div>
      <div class="forum-category-grid">
        <div v-for="group in groupedPosts" :key="group.category" class="forum-category-card">
          <h3>{{ group.category }}</h3>
          <ul>
            <li v-for="post in group.posts" :key="post.url">
              <a :href="post.url">{{ post.title }}</a>
            </li>
          </ul>
        </div>
      </div>
    </section>

    <section class="forum-section">
      <div class="forum-section__head">
        <h2>按年份归档</h2>
      </div>
      <div class="forum-archive-list">
        <div v-for="archive in archivedPosts" :key="archive.year" class="forum-archive-card">
          <h3>{{ archive.year }}</h3>
          <ul>
            <li v-for="post in archive.posts" :key="post.url">
              <a :href="post.url">{{ post.title }}</a>
              <span>{{ formatDate(post.publishAt) }}</span>
            </li>
          </ul>
        </div>
      </div>
    </section>

    <section class="forum-section forum-section--compact">
      <div class="forum-section__head">
        <h2>写作范围</h2>
      </div>
      <div class="forum-topic-chips">
        <span v-for="tag in availableTags.filter((tag) => tag !== '全部')" :key="tag">{{ tag }}</span>
      </div>
    </section>
  </div>
</template>
