# Autoparts
*Um Gerenciador de Pacotes para Nitrous.IO*

### Instalação

Autoparts pode ser encontrado em todas as caixas Nitrous dentro do diretório `~/.parts/autoparts`,
e podem ser utilizadas com o comando `parts`.

Se não estiver instalado (ou tiver sido removido), rode os seguintes comandos no console:

```sh
ruby -e "$(curl -fsSL https://raw.github.com/nitrous-io/autoparts/master/setup.rb)"
exec $SHELL -l
```

### Requerimentos

* Alguns pacotes podem requerer 512MB RAM ou mais.

### Uso

Neste documento nós vamos nos referir a pacotes instaláveis como "parts". Você pode ver todas as parts
que o Autoparts suporta rodando o seguinte comando:

    $ parts search

Autoparts vai automaticamente atualizar a caixa quando iniciado, mas se necessário você pode manualmente
atualizar o repo se você não estiver vendo as últimas atualizações:

    $ parts update

Para instalar a part (ou atualizar uma part existente), utilize o comando install. Por exemplo, para
instalar o PostgreSQL você vai precisar rodar o seguinte comando:

    $ parts install postgresql

Algumas parts como  banco de dados vão precisar serem iniciadas para poder serem utilizadas. Alguns modelos de caixas vão
iniciar o banco de dados durante a inicialização, mas se não você pode iniciar/parar manualmente.

    $ parts start postgresql
    $ parts stop postgresql

Para uma lista completa de comando, rode `parts help`.

### Desenvolvendo no Nitrous.IO

Comece hackeando neste gerenciador de pacotes em
[Nitrous.IO](https://www.nitrous.io/?utm_source=github.com&utm_campaign=Autoparts&utm_medium=hackonnitrous)
em segundos:

[![Hack nitrous-io/autoparts on Nitrous.IO](https://d3o0mnbgv6k92a.cloudfront.net/assets/hack-l-v1-3cc067e71372f6045e1949af9d96095b.png)](https://www.nitrous.io/hack_button?source=embed&runtime=rails&repo=nitrous-io%2Fautoparts&file_to_open=docs%2Fcontributing.md)

### Contribuindo

Veja [contributing.md](https://github.com/nitrous-io/autoparts/tree/master/docs/contributing.md) para documentação completa.

### Línguas Adicionais

[English](https://github.com/action-io/autoparts/blob/master/README.md)

[日本語](https://github.com/action-io/autoparts/blob/master/README.ja.md)

- - -
Copyright (c) 2013-2014 Irrational Industries Inc. d.b.a. Nitrous.IO
This software is licensed under the [BSD 2-Clause license](https://raw.github.com/nitrous-io/autoparts/master/LICENSE).
