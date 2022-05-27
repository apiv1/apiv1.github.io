require 'openssl'

module Crypto
  module_function

  def encrypt(message, password)
    password = digest(password)
    encrypt_data(message.to_s, password, password, "AES-128-CBC")
  end

  def decrypt(message, password)
    password = digest(password)
    decrypt_data(message.to_s, password, password, "AES-128-CBC")
  end

  def decrypt_data(encrypted_data, key, iv, cipher_type)
    aes = OpenSSL::Cipher::Cipher.new(cipher_type)
    aes.decrypt
    aes.key = key
    aes.iv = iv
    aes.update(encrypted_data) + aes.final
  end

  def encrypt_data(data, key, iv, cipher_type)
    aes = OpenSSL::Cipher::Cipher.new(cipher_type)
    aes.encrypt
    aes.key = key
    aes.iv = iv
    aes.update(data) + aes.final
  end

  def digest(key)
    Digest::MD5.digest key
  end
end
