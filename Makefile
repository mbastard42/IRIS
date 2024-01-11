MAKEFLAGS			+=	--silent

BOLD				:=	\033[1m
ITALIC				:=	\033[3m
RED					:=	\e[0;31m
YELLOW				:=	\e[0;33m
GREEN				:=	\e[0;32m
GREY				:=	\033[90m
RESET				:=	\033[0m

BDIR				:=	bin/
NAME				:=	$(BDIR)libui.a
TEST				:=	$(BDIR)test.out

SDIR				:=	src/
SRC					:=	$(shell find $(SDIR) -name "*.cpp")

TDIR				:=	test/
TSRC				:=	$(shell find $(TDIR) -name "*.cpp")

ODIR				:=	.obj/
OBJ					:=	$(subst $(SDIR),$(ODIR), ${SRC:.cpp=.o})
TOBJ				:=	$(subst $(TDIR),$(ODIR), ${TSRC:.cpp=.o})

CC					:=	c++
CFLG				:=	-Wall -Wextra -Werror -std=c++20
LFLG				:=

$(ODIR)%.o			:	$(SDIR)%.cpp

	mkdir -p $(subst $(SDIR),$(ODIR), $(shell dirname $<)/)
	$(CC) $(CFLG) -c $< -o ${addprefix $(ODIR), ${<:$(SDIR)%.cpp=%.o}}
	echo "build\t\t$(YELLOW)compiled$(RESET)\t$(GREY)$(ODIR)${<:$(SDIR)%.cpp=%.o}$(RESET)"
# 
$(ODIR)$(TDIR)%.o	:	$(TDIR)%.cpp

	mkdir -p $(addprefix $(ODIR), $(shell dirname $<)/)
	$(CC) $(CFLG) -c $< -o ${addprefix $(ODIR)$(TDIR), ${<:$(TDIR)%.cpp=%.o}}
	echo "test\t\t$(YELLOW)compiled$(RESET)\t$(GREY)$(ODIR)$(TDIR)${<:$(TDIR)%.cpp=%.o}$(RESET)"
# 
help				:

	echo "$(BOLD)You can run the following commands:$(RESET)$(GREY)\n\
	- build:\tcompile libui\n\
	- test:\t\tcompile test files\n\
	- clean:\tdelete $(ODIR)\n\
	- fclean:\t$(ITALIC)clean$(RESET)$(GREY) and delete $(BDIR)\n\
	- re:\t\t$(ITALIC)fclean$(RESET)$(GREY) and $(ITALIC)build$(RESET)$(GREY)\n\
	- all:\t\t$(ITALIC)build$(RESET)$(GREY), $(ITALIC)test$(RESET)$(GREY) and $(ITALIC)clean$(RESET)$(GREY)"
#
info				:

	echo "$(BOLD)RULE\t\tACTION\t\tTARGET$(RESET)"
#
${NAME}				:	$(OBJ)

	mkdir -p $(BDIR)
	ar rcs $(NAME) $(OBJ)
	echo "$(GREEN)build\t\tlinked\t\t$(BOLD)$(NAME)$(RESET)"
# 
${TEST}				:	$(subst $(ODIR),$(ODIR)$(TDIR), $(TOBJ)) ${NAME}

	mkdir -p $(BDIR)
	$(CC) $(CFLG) $(LFLG) $(subst $(ODIR),$(ODIR)$(TDIR), $(TOBJ)) -o $(TEST) -L./bin/ -lui
	echo "$(GREEN)test\t\tlinked\t\t$(BOLD)$(TEST)$(RESET)"
# 
build				:	info ${NAME}
# 
test				:	info ${TEST}
# 
clean				:	info

	rm -rf $(ODIR)
	echo "$(GREY)clean$(RESET)\t\t$(RED)deleted$(RESET)\t\t$(ODIR)"
# 
fclean				:	info clean

	rm -rf $(BDIR)
	echo "$(GREY)fclean$(RESET)\t\t$(RED)deleted$(RESET)\t\t$(BDIR)"
# 
re					:	info fclean build
# 
all					:	info build test clean
# 
.PHONY				:	help info build clean fclean re all