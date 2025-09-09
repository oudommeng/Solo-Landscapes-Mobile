import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:sololandscapes_moblie/unit/font.dart';

class DescriptionParser {
  static List<Widget> parseEditorJsToWidgets(String? descriptionJson) {
    if (descriptionJson == null || descriptionJson.isEmpty) {
      return [
        Text(
          'No description available.',
          style: KantumruyFont.regular(
            fontSize: 16,
            color: Colors.grey[700],
            height: 1.5,
          ),
        ),
      ];
    }

    try {
      final Map<String, dynamic> parsed = jsonDecode(descriptionJson);
      final List<dynamic> blocks = parsed['blocks'] ?? [];

      List<Widget> widgets = [];

      for (var block in blocks) {
        final String type = block['type'] ?? '';
        final Map<String, dynamic> data = block['data'] ?? {};

        switch (type) {
          case 'paragraph':
            widgets.add(_buildParagraph(data));
            break;
          case 'header':
            widgets.add(_buildHeader(data));
            break;
          case 'list':
            widgets.add(_buildList(data));
            break;
          default:
            // Handle unknown block types as paragraphs
            if (data['text'] != null) {
              widgets.add(_buildParagraph(data));
            }
        }

        // Add spacing between blocks
        if (widgets.isNotEmpty) {
          widgets.add(const SizedBox(height: 12));
        }
      }

      // Remove the last spacing
      if (widgets.isNotEmpty && widgets.last is SizedBox) {
        widgets.removeLast();
      }

      return widgets.isEmpty
          ? [
              Text(
                'No description available.',
                style: KantumruyFont.regular(
                  fontSize: 16,
                  color: Colors.grey[700],
                  height: 1.5,
                ),
              ),
            ]
          : widgets;
    } catch (e) {
      // If parsing fails, return the raw text or error message
      return [
        Text(
          'Description format error. Please contact support.',
          style: KantumruyFont.regular(
            fontSize: 16,
            color: Colors.grey[700],
            height: 1.5,
          ),
        ),
      ];
    }
  }

  static Widget _buildParagraph(Map<String, dynamic> data) {
    String text = data['text'] ?? '';

    // Remove HTML tags for basic formatting
    text = _cleanHtmlText(text);

    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        text,
        style: KantumruyFont.regular(
          fontSize: 16,
          color: Colors.grey[700],
          height: 1.5,
        ),
      ),
    );
  }

  static Widget _buildHeader(Map<String, dynamic> data) {
    String text = data['text'] ?? '';
    int level = data['level'] ?? 1;

    // Remove HTML tags and emojis for cleaner headers
    text = _cleanHtmlText(text);

    double fontSize;
    Color color = const Color(0xFF6B8E23); // primary600

    switch (level) {
      case 1:
        fontSize = 22;
        break;
      case 2:
        fontSize = 20;
        break;
      case 3:
        fontSize = 18;
        break;
      case 4:
        fontSize = 16;
        break;
      default:
        fontSize = 16;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        text,
        style: KantumruyFont.bold(fontSize: fontSize, color: color),
      ),
    );
  }

  static Widget _buildList(Map<String, dynamic> data) {
    List<dynamic> items = data['items'] ?? [];
    String style = data['style'] ?? 'unordered';

    List<Widget> listItems = [];

    for (int i = 0; i < items.length; i++) {
      String itemText = items[i].toString();
      itemText = _cleanHtmlText(itemText);

      // Skip empty items
      if (itemText.trim().isEmpty) continue;

      String bullet = style == 'ordered' ? '${i + 1}. ' : '• ';

      listItems.add(
        Padding(
          padding: const EdgeInsets.only(bottom: 4.0, left: 16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                bullet,
                style: KantumruyFont.regular(
                  fontSize: 16,
                  color: Colors.grey[700],
                ),
              ),
              Expanded(
                child: Text(
                  itemText,
                  style: KantumruyFont.regular(
                    fontSize: 16,
                    color: Colors.grey[700],
                    height: 1.5,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: listItems,
    );
  }

  static String _cleanHtmlText(String text) {
    // Remove common HTML tags and decode entities
    text = text
        .replaceAll(RegExp(r'<[^>]*>'), '') // Remove HTML tags
        .replaceAll('&nbsp;', ' ') // Replace non-breaking space
        .replaceAll('&amp;', '&') // Replace encoded ampersand
        .replaceAll('&lt;', '<') // Replace encoded less than
        .replaceAll('&gt;', '>') // Replace encoded greater than
        .replaceAll(RegExp(r'\\n'), '\n') // Replace escaped newlines
        .replaceAll(
          RegExp(r'\s+'),
          ' ',
        ) // Replace multiple spaces with single space
        .trim();

    return text;
  }
}
