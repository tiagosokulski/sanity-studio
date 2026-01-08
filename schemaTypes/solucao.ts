import { defineField, defineType } from 'sanity'

export default defineType({
  name: 'solucao',
  title: 'Solução',
  type: 'document',
  fields: [
    defineField({
      name: 'setor',
      title: 'Setor',
      type: 'string',
    }),
    defineField({
      name: 'slug',
      title: 'Slug',
      type: 'slug',
      options: {
        source: 'setor',
        maxLength: 96,
      },
    }),
    defineField({
      name: 'mainImage',
      title: 'Main image',
      type: 'image',
      options: {
        hotspot: true,
      },
    }),
    defineField({
      name: 'categories',
      title: 'Categories',
      type: 'array',
      of: [{ type: 'reference', to: { type: 'category' } }],
    }),
    defineField({
      name: 'publishedAt',
      title: 'Published at',
      type: 'datetime',
    }),
    defineField({
      name: 'pitch',
      title: 'Pitch de Vendas',
      type: 'string',
    }),
    defineField({
      name: 'explicacaoDetalhada',
      title: 'Explicação Detalhada',
      type: 'blockContent',
    }),
    defineField({
      name: 'linkTeste',
      title: 'Link para Testar',
      type: 'url',
    }),
    defineField({
      name: 'ordem',
      title: 'Ordem',
      type: 'number',
    }),
  ],

  preview: {
    select: {
      title: 'setor',
      media: 'mainImage',
      subtitle: 'pitch',
    },
    prepare(selection) {
      const { pitch } = selection
      return { ...selection, subtitle: pitch && `${pitch}` }
    },
  },
})
