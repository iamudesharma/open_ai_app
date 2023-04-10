import 'package:dart_openai/openai.dart';

import 'open_api_repo.dart';

class OpenAiRepoImpl extends OpenAiReop {
  List<OpenAIChatCompletionChoiceMessageModel> _messages = [];
  @override
  Future<String?> chatAi({required String text}) async {
    _messages.add(
      OpenAIChatCompletionChoiceMessageModel(
        content: text,
        role: OpenAIChatMessageRole.user,
      ),
    );

    OpenAIChatCompletionModel chat = await OpenAI.instance.chat.create(
      model: "gpt-3.5-turbo",
      messages: _messages,
      maxTokens: 50,
      temperature: 0.5,
    );
    var data = chat.choices.first.message.content;

    _messages.add(
      OpenAIChatCompletionChoiceMessageModel(
        content: data,
        role: OpenAIChatMessageRole.assistant,
      ),
    );

    print(_messages.first.toMap());

    print(_messages.last.toMap());

    return data;
  }

  @override
  Future<String?> completion({required String text}) async {
    // OpenAIChatCompletionModel completion = await OpenAI.instance.chat.create(
    //   model: "gpt-3.5-turbo",
    //   temperature: 0.5,
    //   maxTokens: 50,
    //   messages: [
    //     OpenAIChatCompletionChoiceMessageModel(
    //       content:
    //           'Does this message want to generate an AI picture, image, art or anything similar? $text . Simply answer with a yes or no.',
    //       role: OpenAIChatMessageRole.user,
    //     ),
    //   ],
    // );

    // print(completion.choices.length);

    // print(completion.choices[0].message.content);

    switch (text) {
      case 'create image':
      case 'image create':
      // case 'Yes.':
      // case 'yes.':
        final res = await imageAi(text: text);
        return res[0];
      default:
        final res = await chatAi(text: text);
        return res;
    }
  }

  @override
  Future<List<String>> imageAi({required String text}) async {
    final _data = <String>[];

    var image = await OpenAI.instance.image.create(
      prompt: text,
    );

    for (var i = 0; i < image.data.length; i++) {
      _data.add(image.data[i].url);
    }

    return _data;
  }
}
