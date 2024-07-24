import 'dart:io';

import 'package:chata/models/chat.dart';
import 'package:chata/models/messages.dart';
import 'package:chata/models/user_profile.dart';
import 'package:chata/services/auth_service.dart';
import 'package:chata/services/database_service.dart';
import 'package:chata/services/media_service.dart';
import 'package:chata/services/storage_service.dart';
import 'package:chata/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class ChatPage extends StatefulWidget {
  final UserProfile chatUser;

  const ChatPage({super.key, required this.chatUser});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final GetIt _getIt = GetIt.instance;
  late final AuthService _authService;
  late final DatabaseService _databaseService;
  late final MediaService _mediaService;
  late final StorageService _storageService;
  ChatUser? currentUser, otherUser;

  @override
  void initState() {
    super.initState();
    _storageService = _getIt.get<StorageService>();
    _mediaService = _getIt.get<MediaService>();
    _databaseService = _getIt.get<DatabaseService>();
    _authService = _getIt.get<AuthService>();
    currentUser = ChatUser(
        id: _authService.user!.uid, firstName: _authService.user!.displayName);
    otherUser = ChatUser(
        id: widget.chatUser.uid!,
        firstName: widget.chatUser.name,
        profileImage: widget.chatUser.pfpURL);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.chatUser.name!),
      ),
      body: _buildUi(),
    );
  }

  Widget _buildUi() {
    return StreamBuilder(
        stream:
            _databaseService.getChatMessages(currentUser!.id, otherUser!.id),
        builder: (context, snapshot) {
          Chat? chat = snapshot.data?.data();
          List<ChatMessage> messages = [];

          if (chat != null && chat.messages != null) {
            messages = _generateChatMessages(chat.messages!);
          }
          return DashChat(
              messageOptions:
                  MessageOptions(showOtherUsersAvatar: true, showTime: true),
              inputOptions: InputOptions(alwaysShowSend: true, trailing: [
                _mediaMessageButton(),
              ]),
              currentUser: currentUser!,
              onSend: (message) async {
                await _sendMessage(message);
              },
              messages: messages);
        });
  }

  Future<void> _sendMessage(ChatMessage chatMessage) async {
    if (chatMessage.medias != null ?? false) {
      if (chatMessage.medias!.first.type == MediaType.image) {
        Message _message = Message(
            senderID: chatMessage.user.id,
            content: chatMessage.medias?.first.url,
            messageType: MessageType.Image,
            sentAt: Timestamp.fromDate(chatMessage.createdAt));
        await _databaseService.sendChatMessage(
            uid1: currentUser!.id, uid2: otherUser!.id, message: _message);
      }
    } else {
      Message _message = Message(
        senderID: currentUser!.id,
        content: chatMessage.text,
        messageType: MessageType.Text,
        sentAt: Timestamp.fromDate(chatMessage.createdAt),
      );
      await _databaseService.sendChatMessage(
          uid1: currentUser!.id, uid2: otherUser!.id, message: _message);
    }
  }

  List<ChatMessage> _generateChatMessages(List<Message> messages) {
    List<ChatMessage> chatMessages = messages.map((m) {
      if (m.messageType == MessageType.Image) {
        return ChatMessage(
          user: m.senderID == currentUser!.id ? currentUser! : otherUser!,
          createdAt: m.sentAt!.toDate(),
          medias: [
            ChatMedia(url: m.content!, fileName: "", type: MediaType.image)
          ]
        );
      } else {
        return ChatMessage(
            user: m.senderID == currentUser!.id ? currentUser! : otherUser!,
            createdAt: m.sentAt!.toDate(),
            text: m.content!);
      }
    }).toList();
    chatMessages.sort((a, b) {
      return b.createdAt.compareTo(a.createdAt);
    });
    return chatMessages;
  }

  Widget _mediaMessageButton() {
    return IconButton(
      icon: Icon(Icons.image, color: Theme.of(context).colorScheme.primary),
      onPressed: () async {
        File? file = await _mediaService.getImage();
        if (file != null) {
          String chatID =
              generateChatID(uid1: currentUser!.id, uid2: otherUser!.id);
          String? downloadUrl = await _storageService.uploadImageToChat(
              file: file, chatID: chatID);
          if (downloadUrl != null) {
            // ChatMedia chatMedia = ChatMedia(url: , fileName: fileName, type: type)
            ChatMessage chatMessage = ChatMessage(
                user: currentUser!,
                createdAt: DateTime.now(),
                medias: [
                  ChatMedia(
                      url: downloadUrl, fileName: "", type: MediaType.image)
                ]);
            _sendMessage(chatMessage);
          }
        }
      },
    );
  }
}
