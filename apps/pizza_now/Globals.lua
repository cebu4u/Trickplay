NETWORKING = false

MENU_ITEMS_SEP = 15

if not Coverage then
   dofile("PizzaGlobals.lua")
end

CHANGE_VIEW_TIME = 500
BOTTOM_OPACITY = 90
HIDE_POSITION = {0, -1920}
SHOW_POSITION = {0, 0}

--Globals for form lengths
FOUR_CHARACTERS = 100
THREE_CHARACTERS = 80
TWO_CHARACTERS = 70

Dimensions = {
    HEIGHT = 1080,
    WIDTH = 1920
}

Directions = {
   RIGHT = {1,0},
   LEFT = {-1,0},
   DOWN = {0,1},
   UP = {0,-1}
}

Colors={
   SLATE_GRAY                   ="708090",
   WHITE                        ="FFFFFF",
   FIRE_BRICK                   ="B22222",
   LIME_GREEN                   ="32CD32",
   TURQUOISE                    ="40E0D0",
   BLACK                        ="000000",
   RED                          ="FF0000",
   YELLOW                       ="FFFF00",
   GREEN                        ="00FF00",
   BLUE                         ="0000FF",
   MAGENTA                      ="FF00FF",
   CYAN                         ="00FFFF",
   ORANGE                       ="FFA500",
   PURPLE                       ="A020F0",
   PERU                         ="CD853F",
}

Characters={
   [keys.space] = ' ',
   [keys['0']] = '0',
   [keys['1']] = '1',
   [keys['2']] = '2',
   [keys['3']] = '3',
   [keys['4']] = '4',
   [keys['5']] = '5',
   [keys['6']] = '6',
   [keys['7']] = '7',
   [keys['8']] = '8',
   [keys['9']] = '9',
   [keys.colon] = ':',
   [keys.semicolon] = ';',
   [keys.less] = '<',
   [keys.equal] = '=',
   [keys.greater] = '>',
   [keys.question] = '?',
   [keys.at] = '@',
   [keys.A] = 'A',
   [keys.B] = 'B',
   [keys.C] = 'C',
   [keys.D] = 'D',
   [keys.E] = 'E',
   [keys.F] = 'F',
   [keys.G] = 'G',
   [keys.H] = 'H',
   [keys.I] = 'I',
   [keys.J] = 'J',
   [keys.K] = 'K',
   [keys.L] = 'L',
   [keys.M] = 'M',
   [keys.N] = 'N',
   [keys.O] = 'O',
   [keys.P] = 'P',
   [keys.Q] = 'Q',
   [keys.R] = 'R',
   [keys.S] = 'S',
   [keys.T] = 'T',
   [keys.U] = 'U',
   [keys.V] = 'V',
   [keys.W] = 'W',
   [keys.X] = 'X',
   [keys.Y] = 'Y',
   [keys.Z] = 'Z',
   [keys.bracketleft] = '[',
   [keys.backslash] = '\\',
   [keys.slash] = '/',
   [keys.bracketright] = ']',
   [keys.asciicircum] = 'asciicircum',
   [keys.underscore] = '_',
   [keys.grave] = 'grave',
   [keys.quoteleft] = '`',
   [keys.quoteright] = '\'',
   [keys.a] = 'a',
   [keys.b] = 'b',
   [keys.c] = 'c',
   [keys.d] = 'd',
   [keys.e] = 'e',
   [keys.f] = 'f',
   [keys.g] = 'g',
   [keys.h] = 'h',
   [keys.i] = 'i',
   [keys.j] = 'j',
   [keys.k] = 'k',
   [keys.l] = 'l',
   [keys.m] = 'm',
   [keys.n] = 'n',
   [keys.o] = 'o',
   [keys.p] = 'p',
   [keys.q] = 'q',
   [keys.r] = 'r',
   [keys.s] = 's',
   [keys.t] = 't',
   [keys.u] = 'u',
   [keys.v] = 'v',
   [keys.w] = 'w',
   [keys.x] = 'x',
   [keys.y] = 'y',
   [keys.z] = 'z',
   [keys.comma] = ',',
   [keys.period] = '.',
   [keys.minus] = '-',
}

CUSTOMIZE_TINY_FONT = "KacstArt 24px"
CUSTOMIZE_TINIER_FONT = "KacstArt 20px"
CUSTOMIZE_TAB_FONT  = "KacstArt 48px"
CUSTOMIZE_ENTRY_FONT = "KacstArt 28px"
CUSTOMIZE_SUB_FONT  = "KacstArt 32px"
CUSTOMIZE_SUB_FONT_B  = "KacstArt 36px"
CUSTOMIZE_SUB_FONT_SP  = "KacstArt 42px"
CUSTOMIZE_NAME_FONT = "KacstArt 144px"
DEFAULT_FONT="Sans 40px"
DEFAULT_COLOR=Colors.WHITE
OFFICE = {
   address="411 Acacia Avenue",
   city="Palo Alto",
   state="CA"
}
