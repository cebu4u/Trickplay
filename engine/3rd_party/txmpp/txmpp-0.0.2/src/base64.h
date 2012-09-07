
//*********************************************************************
//* C_Base64 - a simple base64 encoder and decoder.
//*
//*     Copyright (c) 1999, Bob Withers - bwit@pobox.com
//*
//* This code may be freely used for any purpose, either personal
//* or commercial, provided the authors copyright notice remains
//* intact.
//*********************************************************************

#ifndef TXMPP_BASE64_H__
#define TXMPP_BASE64_H__

#ifndef NO_CONFIG_H
#include "config.h"
#endif

#include <string>
#include <vector>

namespace txmpp {

class Base64
{
public:
  enum DecodeOption {
    DO_PARSE_STRICT =  1,  // Parse only base64 characters
    DO_PARSE_WHITE  =  2,  // Parse only base64 and whitespace characters
    DO_PARSE_ANY    =  3,  // Parse all characters
    DO_PARSE_MASK   =  3,

    DO_PAD_YES      =  4,  // Padding is required
    DO_PAD_ANY      =  8,  // Padding is optional
    DO_PAD_NO       = 12,  // Padding is disallowed
    DO_PAD_MASK     = 12,

    DO_TERM_BUFFER  = 16,  // Must termiante at end of buffer
    DO_TERM_CHAR    = 32,  // May terminate at any character boundary
    DO_TERM_ANY     = 48,  // May terminate at a sub-character bit offset
    DO_TERM_MASK    = 48,

    // Strictest interpretation
    DO_STRICT = DO_PARSE_STRICT | DO_PAD_YES | DO_TERM_BUFFER,

    DO_LAX    = DO_PARSE_ANY | DO_PAD_ANY | DO_TERM_CHAR,
  };
  typedef int DecodeFlags;

  static bool IsBase64Char(char ch);

  // Determines whether the given string consists entirely of valid base64
  // encoded characters.
  static bool IsBase64Encoded(const std::string& str);

  static void EncodeFromArray(const void* data, size_t len,
                              std::string* result);
  static bool DecodeFromArray(const char* data, size_t len, DecodeFlags flags,
                              std::string* result, size_t* data_used);
  static bool DecodeFromArray(const char* data, size_t len, DecodeFlags flags,
                              std::vector<char>* result, size_t* data_used);

  // Convenience Methods
  static inline std::string Encode(const std::string& data) {
    std::string result;
    EncodeFromArray(data.data(), data.size(), &result);
    return result;
  }
  static inline std::string Decode(const std::string& data, DecodeFlags flags) {
    std::string result;
    DecodeFromArray(data.data(), data.size(), flags, &result, NULL);
    return result;
  }
  static inline bool Decode(const std::string& data, DecodeFlags flags,
                            std::string* result, size_t* data_used)
  {
    return DecodeFromArray(data.data(), data.size(), flags, result, data_used);
  }
  static inline bool Decode(const std::string& data, DecodeFlags flags,
                            std::vector<char>* result, size_t* data_used)
  {
    return DecodeFromArray(data.data(), data.size(), flags, result, data_used);
  }

private:
  static const std::string Base64Table;
  static const unsigned char DecodeTable[];

  static size_t GetNextQuantum(DecodeFlags parse_flags, bool illegal_pads,
                               const char* data, size_t len, size_t* dpos,
                               unsigned char qbuf[4], bool* padded);
  template<typename T>
  static bool DecodeFromArrayTemplate(const char* data, size_t len,
                                      DecodeFlags flags, T* result,
                                      size_t* data_used);
};

}  // namespace txmpp

#endif  // TXMPP_BASE64_H_
