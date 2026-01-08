export default {
  name: 'solucao',
  title: 'Solução',
  type: 'document',
  fields: [
    {
      name: 'setor',
      title: 'Setor',
      type: 'string',
    },
    {
      name: 'slug',
      title: 'Slug',
      type: 'slug',
      options: {
        source: 'setor',
        maxLength: 96,
      },
    },
    {
      name: 'pitch',
      title: 'Pitch de Vendas',
      type: 'text',
    },
    {
      name: 'explicacao',
      title: 'Explicação Detalhada',
      type: 'array',
      of: [{ type: 'block' }],
    },
    {
      name: 'link',
      title: 'Link para Testar',
      type: 'url',
    },
    {
      name: 'ordem',
      title: 'Ordem',
      type: 'number',
    },
  ],
};
