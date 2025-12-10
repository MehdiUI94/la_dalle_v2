<template>
  <div class="custom-scrollbar-wrapper" ref="wrapperRef">
    <div class="custom-scrollbar-content" ref="contentRef">
      <slot />
    </div>
    <div 
      v-if="showScrollbar"
      class="custom-scrollbar-track"
      :class="{ 'with-header': hasHeader, 'with-footer': hasFooter }"
      ref="trackRef"
      @mousedown="handleTrackClick"
    >
      <div 
        class="custom-scrollbar-thumb"
        ref="thumbRef"
        :style="thumbStyle"
        @mousedown="handleThumbMouseDown"
      ></div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, computed, onMounted, onUnmounted, watch, nextTick } from 'vue'
import { useRoute } from 'vue-router'

interface Props {
  hasHeader?: boolean
  hasFooter?: boolean
}

const props = withDefaults(defineProps<Props>(), {
  hasHeader: false,
  hasFooter: false
})

const route = useRoute()
const wrapperRef = ref<HTMLElement | null>(null)
const contentRef = ref<HTMLElement | null>(null)
const trackRef = ref<HTMLElement | null>(null)
const thumbRef = ref<HTMLElement | null>(null)

const scrollTop = ref(0)
const scrollHeight = ref(0)
const clientHeight = ref(0)
const showScrollbar = ref(false)
const isDragging = ref(false)
const dragStartY = ref(0)
const dragStartScrollTop = ref(0)

const thumbHeight = computed(() => {
  if (!trackRef.value || clientHeight.value === 0 || scrollHeight.value === 0) return 0
  const trackHeight = trackRef.value.clientHeight
  const height = (clientHeight.value / scrollHeight.value) * trackHeight
  return Math.max(20, height) // Minimum 20px
})

const thumbTop = computed(() => {
  if (!trackRef.value || clientHeight.value === 0 || scrollHeight.value === 0 || scrollHeight.value <= clientHeight.value) return 0
  const trackHeight = trackRef.value.clientHeight
  const scrollableHeight = scrollHeight.value - clientHeight.value
  if (scrollableHeight <= 0) return 0
  const top = (scrollTop.value / scrollableHeight) * (trackHeight - thumbHeight.value)
  return Math.max(0, Math.min(top, trackHeight - thumbHeight.value))
})

const thumbStyle = computed(() => ({
  height: `${thumbHeight.value}px`,
  top: `${thumbTop.value}px`
}))

const updateScrollbar = () => {
  if (!contentRef.value || !wrapperRef.value) return
  
  // Utiliser requestAnimationFrame pour s'assurer que le DOM est complètement rendu
  requestAnimationFrame(() => {
    if (!contentRef.value) return
    
    scrollTop.value = contentRef.value.scrollTop
    scrollHeight.value = contentRef.value.scrollHeight
    clientHeight.value = contentRef.value.clientHeight
    
    // Afficher la scrollbar uniquement si le contenu dépasse vraiment la hauteur visible
    // Utiliser une marge de 2px pour éviter les problèmes d'arrondi et de padding
    // Vérifier aussi que scrollHeight et clientHeight sont valides
    const hasValidDimensions = scrollHeight.value > 0 && clientHeight.value > 0
    const needsScroll = hasValidDimensions && scrollHeight.value > clientHeight.value + 2
    
    showScrollbar.value = needsScroll
  })
}

const handleScroll = () => {
  updateScrollbar()
}

const handleThumbMouseDown = (e: MouseEvent) => {
  e.preventDefault()
  e.stopPropagation()
  isDragging.value = true
  dragStartY.value = e.clientY
  dragStartScrollTop.value = scrollTop.value
  document.addEventListener('mousemove', handleMouseMove)
  document.addEventListener('mouseup', handleMouseUp)
}

const handleMouseMove = (e: MouseEvent) => {
  if (!isDragging.value || !trackRef.value || !contentRef.value) return
  
  const trackRect = trackRef.value.getBoundingClientRect()
  const trackHeight = trackRect.height
  const deltaY = e.clientY - dragStartY.value
  const scrollRatio = (scrollHeight.value - clientHeight.value) / trackHeight
  const newScrollTop = dragStartScrollTop.value + deltaY * scrollRatio
  
  contentRef.value.scrollTop = Math.max(0, Math.min(newScrollTop, scrollHeight.value - clientHeight.value))
}

const handleMouseUp = () => {
  isDragging.value = false
  document.removeEventListener('mousemove', handleMouseMove)
  document.removeEventListener('mouseup', handleMouseUp)
}

const handleTrackClick = (e: MouseEvent) => {
  if (!trackRef.value || !contentRef.value || e.target === thumbRef.value) return
  
  const trackRect = trackRef.value.getBoundingClientRect()
  const clickY = e.clientY - trackRect.top
  const trackHeight = trackRect.height
  const scrollRatio = clickY / trackHeight
  const newScrollTop = scrollRatio * (scrollHeight.value - clientHeight.value)
  
  contentRef.value.scrollTop = Math.max(0, Math.min(newScrollTop, scrollHeight.value - clientHeight.value))
}

// Réinitialiser le scroll en haut lors du changement de route
watch(() => route.path, () => {
  nextTick(() => {
    if (contentRef.value) {
      contentRef.value.scrollTop = 0
      updateScrollbar()
    }
  })
})

onMounted(() => {
  if (contentRef.value) {
    contentRef.value.addEventListener('scroll', handleScroll)
    
    // Mettre à jour après un court délai pour laisser le DOM se stabiliser
    setTimeout(() => {
      updateScrollbar()
      // Double vérification après un délai supplémentaire
      setTimeout(updateScrollbar, 100)
    }, 0)
    
    // Observer les changements de taille du contenu
    const resizeObserver = new ResizeObserver(() => {
      // Utiliser setTimeout pour s'assurer que le DOM est mis à jour
      setTimeout(updateScrollbar, 50)
    })
    resizeObserver.observe(contentRef.value)
    
    // Observer aussi les changements de contenu
    const mutationObserver = new MutationObserver(() => {
      setTimeout(updateScrollbar, 50)
    })
    mutationObserver.observe(contentRef.value, {
      childList: true,
      subtree: true,
      attributes: true,
      attributeFilter: ['style', 'class']
    })
    
    onUnmounted(() => {
      resizeObserver.disconnect()
      mutationObserver.disconnect()
      contentRef.value?.removeEventListener('scroll', handleScroll)
    })
  }
})

// Surveiller les changements de scrollHeight et clientHeight
watch(() => [contentRef.value?.scrollHeight, contentRef.value?.clientHeight], () => {
  setTimeout(updateScrollbar, 0)
}, { deep: true })
</script>

<style scoped>
.custom-scrollbar-wrapper {
  position: relative;
  height: 100%;
  width: 100%;
  display: flex;
  overflow: hidden; /* Empêcher tout débordement */
}

.custom-scrollbar-content {
  flex: 1;
  overflow-y: auto;
  overflow-x: hidden;
  padding-right: 8px;
  /* S'assurer que le contenu peut scroller */
  box-sizing: border-box;
  scrollbar-width: none; /* Firefox */
  -ms-overflow-style: none; /* IE/Edge */
  /* Permettre au contenu de dépasser la hauteur du conteneur pour activer le scroll */
  min-height: 100%;
}

.custom-scrollbar-content::-webkit-scrollbar {
  display: none; /* Chrome/Safari */
}

.custom-scrollbar-track {
  position: absolute;
  right: 16px; /* Décollé du bord droit */
  top: 16px; /* Décollé par défaut */
  bottom: 16px; /* Décollé par défaut */
  width: 12px;
  background: rgba(255, 255, 255, 0.1);
  border-radius: 6px;
  cursor: pointer;
  z-index: 10;
  /* Ne pas bloquer le scroll de la souris sur le contenu */
  pointer-events: none;
}

/* Ajuster le top si le header est présent - 40px d'espace entre header et scrollbar */
.custom-scrollbar-track.with-header {
  top: 40px; /* 40px d'espace entre le header et la scrollbar */
}

/* Ajuster le bottom si le footer est présent */
.custom-scrollbar-track.with-footer {
  bottom: 120px; /* Décollé du footer + 40px pour raccourcir la scrollbar */
}

/* Si header ET footer sont présents */
.custom-scrollbar-track.with-header.with-footer {
  top: 40px; /* 40px d'espace entre le header et la scrollbar */
  bottom: 120px; /* Décollé du footer + 40px pour raccourcir la scrollbar */
}

.custom-scrollbar-track:hover,
.custom-scrollbar-track:active {
  pointer-events: auto;
}

.custom-scrollbar-thumb {
  position: absolute;
  width: 100%;
  background: rgba(255, 255, 255, 0.3);
  border-radius: 6px;
  border: 2px solid rgba(255, 255, 255, 0.1);
  cursor: grab;
  transition: background 0.2s;
  pointer-events: auto;
}

.custom-scrollbar-thumb:hover {
  background: rgba(255, 255, 255, 0.5);
}

.custom-scrollbar-thumb:active {
  cursor: grabbing;
  background: rgba(255, 255, 255, 0.6);
}
</style>

