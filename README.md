# CAFÉ DO PADRIM — V3 CONECTADO

Esta versão já está configurada para o projeto Supabase informado pelo administrador.

## Contas
- Criar perfil usando e-mail (incluindo Gmail) e senha própria.
- Login por e-mail + senha.
- Aba PERFIL.
- Trocar de conta / sair.
- Recuperação e alteração de senha.
- Cada usuário possui dados separados por RLS.

## Importante
A chave usada no navegador é a Publishable key, apropriada para uso público quando o RLS está configurado. Nunca coloque uma Secret/service_role key no aplicativo.

## Para colocar no ar
Publique os arquivos em um serviço de hospedagem HTTPS. No iPhone/iPad, abra no Safari e use Compartilhar → Adicionar à Tela de Início.


## Compatibilidade
Esta versão usa a chave anon legada pública do Supabase para máxima compatibilidade com @supabase/supabase-js em hospedagem estática. A chave anon é segura para uso no navegador quando o RLS está configurado.
