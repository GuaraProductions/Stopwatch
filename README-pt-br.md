# Cronômetro
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
![Godot Engine](https://img.shields.io/badge/GODOT-%23FFFFFF.svg?style=for-the-badge&logo=godot-engine)

Um nó utilitário de cronômetro para Godot 4.x

https://github.com/GuaraProductions/Stopwatch/assets/91577/10b0d6cb-3478-4e51-bf92-4ec04cb15217

### **Versão do Godot: 4.5**
### **Versão atual: 1.1.1**

Este plugin encapsula a funcionalidade de um cronômetro, oferecendo recursos avançados além da medição de tempo básica. Ele calcula com precisão a duração entre a ativação e a desativação, fornecendo a capacidade de pausar o cronômetro e zerar o temporizador conforme necessário. Além disso, o plugin permite que os usuários recuperem o tempo atual em uma string formatada, facilitando a integração perfeita com nós de texto para fácil exibição.

O vídeo acima é uma das cenas de demonstração, mostrando o que pode ser feito com este plugin, e também uma demonstração de como você pode usar este plugin de forma eficaz. Você pode encontrar esta demonstração na pasta "examples" do projeto.

## Como baixar

Vá para a seção de download deste repositório do GitHub e baixe a versão mais recente do plugin.

Após o download, extraia o conteúdo do zip para a pasta `addons`. O diretório do seu projeto deve ficar parecido com isto:

```
Your Project
    addons
        stopwatch
            ...plugin files
        ...other plugins
    ...other files
```
# Documentação

No futuro, farei uma demonstração em vídeo sobre como usar este plugin. Por enquanto, aqui está a documentação que já existe no código.

Obs.: Você pode acessar esta documentação clicando no logo do cronômetro com o botão direito do mouse.

![image](https://github.com/GuaraProductions/Stopwatch/assets/9157977/0fa3a20a-8f0c-4d0a-a4ef-47c555abd8e8)

## Propriedades

 - float elapsed_time [padrão: 0.0] [propriedade: setter, getter]
 - bool paused [padrão: true] [propriedade: setter, getter]
 - Array[Array] checkpoints [propriedade: setter, getter]

### Export

 - String process_callback [padrão: "Idle"]
 - bool autostart [padrão: false]
 - bool pause_on_reset [padrão: false]

## Métodos

 - Array add_checkpoint()
 - Dictionary get_elapsed_time_as_dictionary()
 - String get_elapsed_time_as_formatted_string(format: String)
 - static String get_time_as_formatted_string(time_in_seconds: float, format: String)
 - static Dictionary get_time_dictionary_from_seconds(total_time_in_seconds: float)
 - void reset()
 - void toggle_pause()

## Sinais

### new_checkpoint(checkpoint: float, diff_previous: float)

Emitido quando um novo checkpoint é adicionado, retorna o tempo decorrido quando o checkpoint é solicitado e a diferença entre este checkpoint e o anterior.

### pause_state_changed(status: bool)

Emitido quando o status de pausa é alterado, retorna se o cronômetro está atualmente pausado ou não.

### time_resetted(time: float)

Emitido quando o cronômetro é zerado, retorna o tempo decorrido antes de ser zerado.


## Descrição das Propriedades

### String process_callback [padrão: "Idle"]

Determina se o processamento do tempo decorrido é calculado durante os frames de processo (`_process`) ou durante os frames de física (`_physics_process`). Obs.: Só tem efeito quando o nó entra na SceneTree pela primeira vez.


### bool autostart [padrão: false]

Determina se o cronômetro inicia depois que o nó está pronto ou não.


### bool pause_on_reset [padrão: false]

Determina se o cronômetro pausa quando é zerado.


### float elapsed_time [padrão: 0.0] [propriedade: setter, getter]

Quantidade de segundos decorridos desde o início.


### bool paused [padrão: true] [propriedade: setter, getter]

Determina se a execução do cronômetro está pausada ou não.


### Array[Array] checkpoints [propriedade: setter, getter]

Um array contendo todos os tempos em que um checkpoint foi solicitado. O tempo é mantido dentro de um Array com duas posições, a primeira é o tempo decorrido quando o checkpoint foi solicitado, e a segunda posição contém a diferença entre o checkpoint atual e o anterior.


## Descrição dos Métodos

### Array add_checkpoint()

Adiciona um checkpoint ao cronômetro com base em seu tempo decorrido, retorna um array com o tempo decorrido atual e a diferença entre o tempo decorrido atual e o último checkpoint.

Nota: esta função não leva em conta se o cronômetro está pausado ou não, então tenha isso em mente ao invocar esta função.


### Dictionary get_elapsed_time_as_dictionary()

Obtém o tempo decorrido desde o tempo de início do cronômetro e retorna um dicionário representando o tempo em horas, minutos, segundos e milissegundos.


### String get_elapsed_time_as_formatted_string(format: String)

Formata o valor do tempo decorrido atual em uma string com base no formato especificado. O "format" é uma string contendo placeholders para dia, hora, minuto, segundo e milissegundo.

Placeholders: "{dd}" para dia, "{hh}" para hora, "{MM}" para minutos, "{ss}" para segundos, "{mmm}" para milissegundos.

Retorna:

String: A string de tempo formatada com base no formato fornecido.

Exemplo:

```gdscript
  @export var stopwatch : Stopwatch
  ...
  var time: float = 1234.567
  
  var formatted_time_str: String = stopwatch.format_time("{dd}:{hh}:{MM}:{ss}:{mmm}")
  print("Formatted Time:", formatted_time_str)
```

Este exemplo produzirá uma string representando o tempo como "00:00:20:34:567", onde:

- 00 dias,
- 00 horas,
- 20 minutos,
- 34 segundos,
- 567 milissegundos. 

Nota: Existe uma versão estática desta função chamada Stopwatch.get_time_as_formatted_string()

### String get_time_as_formatted_string(time_in_seconds: float, format: String) static
Esta função é uma versão estática da função Stopwatch.get_elapsed_time_as_formatted_string(). Funciona da mesma forma, com a única diferença de que aqui você precisa fornecer o parâmetro time_in_seconds.

### Dictionary get_time_dictionary_from_seconds(total_time_in_seconds: float) static
Converte um tempo em segundos para um dicionário representando o tempo em horas, minutos, segundos e milissegund
"hours" : armazena as horas
"minutes" : armazena os minutos
"seconds" : armazena os segundos
"milliseconds" : armazena os milissegundos

### void reset()
Zera o tempo decorrido atual.

### void toggle_pause()
Alterna o estado de pausa do cronômetro, dependendo do estado anterior.

Licença
Este projeto está licenciado sob a licença MIT.






