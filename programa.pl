% 1)
% Jugadores
% jugador(Nombre, PuntosVida, PuntosMana, CartasMazo, CartasMano, CartasCampo)

% Cartas
% criatura(Nombre, PuntosDaño, PuntosVida, CostoMana)
% hechizo(Nombre, FunctorEfecto, CostoMana)

% Efectos
% danio(CantidadDanio)
% cura(CantidadCura)

nombre(jugador(Nombre,_,_,_,_,_), Nombre).
nombre(criatura(Nombre,_,_,_), Nombre).
nombre(hechizo(Nombre,_,_), Nombre).

vida(jugador(_,Vida,_,_,_,_), Vida).
vida(criatura(_,_,Vida,_), Vida).
vida(hechizo(_,curar(Vida),_), Vida).

danio(criatura(_,Danio,_), Danio).
danio(hechizo(_,danio(Danio),_), Danio).

mana(jugador(_,_,Mana,_,_,_), Mana).
mana(criatura(_,_,_,Mana), Mana).
mana(hechizo(_,_,Mana), Mana).

cartasMazo(jugador(_,_,_,Cartas,_,_), Cartas).
cartasMano(jugador(_,_,_,_,Cartas,_), Cartas).
cartasCampo(jugador(_,_,_,_,_,Cartas), Cartas).

% 1)
tieneCarta(Jugador,Carta):-
    cartasMazo(Jugador,Cartas),
    member(Carta,Cartas).

tieneCarta(Jugador,Carta):-
    cartasMano(Jugador,Cartas),
    member(Carta,Cartas).

tieneCarta(Jugador,Carta):-
    cartasCampo(Jugador,Cartas),
    member(Carta,Cartas).

% 2)
guerrero(Jugador):-
    tieneCarta(Jugador,_),
    forall(tieneCarta(Jugador,Carta),
        esCriatura(Carta)).

esCriatura(criatura(_,_,_,_)).

% 3)
empezarTurno(Jugador,JugadorPostTurno):-
    tieneCarta(Jugador,_),
    tieneCarta(JugadorPostTurno,_),
    primerCartaMazoPasaAMano(Jugador,JugadorPostTurno),
    modificarMana(Jugador,JugadorPostTurno,1).

primerCartaMazoPasaAMano(Jugador,JugadorPostTurno):-
    cartasMazo(Jugador,[PrimerCarta|_]),
    cartasMano(JugadorPostTurno,CartasMano),
    member(PrimerCarta,CartasMano).

modificarMana(Jugador,JugadorPostMana,Cuanto):-
    mana(Jugador,Mana),
    mana(JugadorPostMana,ManaPost),
    ManaPost is Mana + Cuanto.

% 4)
% a)
puedeJugar(Jugador,Carta):-
    tieneCarta(Jugador,Carta),
    mana(Carta, ManaNecesario),
    mana(Jugador, ManaDisponible),
    ManaDisponible >= ManaNecesario.

% b)
puedeJugarProximoTurno(Jugador,JugadorPostTurno,Carta):-
    empezarTurno(Jugador,JugadorPostTurno),
    estaEnLaMano(JugadorPostTurno,Carta),
    puedeJugar(JugadorPostTurno,Carta).

estaEnLaMano(Jugador,Carta):-
    cartasMano(Jugador,Cartas),
    member(Carta,Cartas).

% 5)
% jugar(Carta,Jugador,JugadorPostCarta).

cartasPosiblesHastaAgotarMana([Jugador | JugadoresPostTurno],[Carta | Cartas]):-
    puedeJugarProximoTurno(Jugador,JugadoresPostTurno,Carta),
    