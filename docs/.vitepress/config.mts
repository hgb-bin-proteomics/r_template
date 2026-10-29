import { defineConfig } from 'vitepress'

// https://vitepress.dev/reference/site-config
export default defineConfig({
  base: "/r_template/",
  srcDir: "md",
  title: "R Template",
  description: "A template repository for R projects.",
  head: [
    [
      "link",
      {
        rel: "icon",
        href: "https://bioart.niaid.nih.gov/api/bioarts/411/files/633468.png",
      },
    ],
  ],
  markdown: {
   theme: {
     light: "catppuccin-latte",
     dark: "catppuccin-mocha",
    },
  },
  lastUpdated: true,
  themeConfig: {
    logo: {
      src: "https://bioart.niaid.nih.gov/api/bioarts/411/files/633468.png",
      alt: "logo",
    },
    // https://vitepress.dev/reference/default-theme-config
    nav: [
      { text: "Home", link: "/" },
      { text: "Template", link: "/template" },
      { text: "Tooling", link: "/tooling" },
      { text: "Usage", link: "/usage" },
      { text: "About", link: "/about" },
    ],
    sidebar: [
      {
        items: [
          { text: "Template", link: "/template" },
          { text: "Tooling", link: "/tooling" },
          { text: "Documentation", link: "/documentation" },
          { text: "Docker", link: "/docker" },
          { text: "Usage", link: "/usage" },
          { text: "About", link: "/about" },
        ],
      },
    ],
    footer: {
      message: "Released under the MIT License.",
      copyright: "Copyright © 2026 Micha J. Birklbauer"
    },
    socialLinks: [{ icon: "github", link: "https://github.com/michabirklbauer/r_template" }],
    search: {
        provider: 'local'
    },
    editLink: {
      pattern: 'https://github.com/michabirklbauer/r_template/edit/master/docs/md/:path'
    },
  },
})
