%Hacia la disciplina de constructores. 
%Detectar los simboles constantes y los funtores y Los simboles de predicados. 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%este es el que lee y  crea el archivo
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



main:-write('nombre programa'),nl,
       read(N),E='.pl',
       concat(N,E,R),
       print(R),nl,
       open(R,write,ID,[alias(input)]),
       %ahora se escribe el query
       condicion(input).

condicion(input) :-repeat,
                   write('ingrese linea'),nl,
                   read(X),
                  (not(X==fin)->
                   escribir(input,X);
                   cerrar(input)).

escribir(input,X):- numbervars(X,0,End),
                    write(input,X),write(input,'.'),
                    write(input,'\n'),nl,
                    condicion(input).

cerrar(input):- close(input),!,print('terminó'),nl.



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%abrir imprimir sin pasar a lista
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

abrir:- write('ingrese el nombre del programa'),nl,
        read(N),E='.pl', 
        concat(N,E,R),
        print('abriendo '),print(R),nl,
        open(R,read,B),
        read(B,X),
        sigue(X,B).

sigue(X,B):-(not(X==end_of_file))->numbervars(X,0,End),write(X),write('.'),nl,
            read(B,T),sigue(T,B);true. 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%para demostrar el uso de numbervars lo podemos ver con la siguiente clausula, read(X),numbervars(X,0,End),write(X).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%abrir pasando hechos y clausulas a lista
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

predicado(X,R):- X=..R.

abriralista(L):- write('ingrese el nombre del programa'),nl,
                 read(N),E='.pl', 
                 concat(N,E,R),
                 print('abriendo '),print(R),nl,
                 open(R,read,B),
                 read(B,X),
                 sigueo(A,X,B,L).

              
sigueo(A,X,B,L):- (not(X==end_of_file))->numbervars(X,0,End),predicado(X,R),
                  read(B,T),sigueo1([R],T,B,RE,L);L=A,true.        


sigueo1(A,X,B,Re,L):-(not(X==end_of_file))->numbervars(X,0,End),predicado(X,R),append(A,[R],Re),
                  read(B,T),sigueo1(Re,T,B,_,L);L=A,true.


%analizar programa


analizarprograma :- abriralista(L),analizarlinea(L).


%analizar linea por linea
analizarlinea([]).
analizarlinea([H|C]):-nl,detectar(H),analizarlinea(C).


%detectar clausula
detectar([:-|[H|C]]):-write('clausula *'),
                      write(H),
                      write('* con cuerpo '),C=[He|_],detectarcuerpo(He,1).

%detectar cuerpo clausula
detectarcuerpo(C,N):- (arg(N,C,F))->(write(' predicado *'),write(F),write('* '),S is N+1,detectarcuerpo(C,S));true.



%detectar predicado
detectar([H|C]):-write('*'),write(H),write('*'),write(' es predicado '),write('aridad '),length(C,R),write(R),write(' '),detectarcola(C).

%detectar cola predicado(argumentos)
detectarcola([]).
detectarcola([H|C]):-atom(H),write('*'),print(H),write('*'),write(' es constante '),detectarcola(C).
detectarcola([H|C]):-nonvar(H),write('*'),print(H),write('*'),write(' es variable '),detectarcola(C).
