# Inspired by CheckStructMember.cmake

INCLUDE(CheckCSourceCompiles)

MACRO (CHECK_TYPE _TYPE _HEADER _RESULT)
   SET(_INCLUDE_FILES)
   FOREACH (it ${_HEADER})
      SET(_INCLUDE_FILES "${_INCLUDE_FILES}#include <${it}>\n")
   ENDFOREACH (it)

   SET(_CHECK_TYPE_SOURCE_CODE "
${_INCLUDE_FILES}
int main()
{
   static ${_TYPE} tmp;
  return 0;
}
")
   CHECK_C_SOURCE_COMPILES("${_CHECK_TYPE_SOURCE_CODE}" ${_RESULT})

ENDMACRO (CHECK_TYPE)
