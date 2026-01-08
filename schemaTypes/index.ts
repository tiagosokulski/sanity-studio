import blockContent from './blockContent'
import { defineType, defineArrayMember } from 'sanity'
import post from './post'
import author from './author'
import category from './category'
import solucao from './solucao'

export const schemaTypes = [post, author, category, solucao, blockContent]
