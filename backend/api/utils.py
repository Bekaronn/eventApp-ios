def jwt_response_payload_handler(token, user=None, request=None):
    return {
        'token': token,
        'user_id': user.id,
        'email': user.email
        # Другие данные пользователя, которые вы хотите включить в ответ
    }