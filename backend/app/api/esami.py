from app.api import bp 
from app.extensions import session
from flask import jsonify, request
from flask_jwt_extended import *
from sqlalchemy import insert

from app.utils import genera_date_appello
from app.models.Esame import Esame
from app.models.Prova import Prova
from app.models.Realizza import Realizza
from app.models.Appello import Appello

@bp.route('/esami/crea', methods=['POST'])
@jwt_required()
def inserisci_in_libretto():
    try:
        current_user = get_jwt_identity()
        if current_user['role'] == 'Studente':
            return jsonify({"Error":"Not Allowed"}), 403

        idesame = request.json["idesame"]
        nome = request.json["nome"]
        crediti = request.json["crediti"]
        anno = request.json["anno"]
        prove = request.json["prove"]
        collaboratori = request.json["collaboratori"]

        if not idesame or not nome or not crediti or not anno or not prove or not collaboratori:
            return jsonify({"Error":"Missing parameters"}), 400

        query = insert(Esame).values(
            idesame = idesame,
            nome = nome,
            crediti = crediti,
            anno = anno
        )

        session.execute(query)

        query = insert(Realizza).values(
            email = current_user['email'],
            idesame = idesame
        )

        session.execute(query)

        #TO-DO: opzionale deve avere valori uguali a true o false
        for index, prova in enumerate(prove, start=1):
            idprova = f"{idesame}-{index}",
            query = insert(Prova).values(
                idprova = idprova,
                tipologia = prova.get("tipologia"),
                opzionale = prova.get("opzionale"),
                datascadenza = prova.get("datascadenza"),
                dipendeda = prova.get("dipendeda") if prova.get("dipendeda") != "" else None,
                idesame = idesame,
                responsabile = current_user['email']
            )
            session.execute(query)
            
            date_appelli = genera_date_appello(4)

            for data in date_appelli:
                query = insert(Appello).values(
                    idprova = idprova,
                    data = data
                )
                session.execute(query)

        for collaboratore in collaboratori:
            query = insert(Realizza).values(
                email = collaboratore,
                idesame = idesame
            )

            session.execute(query)
        
        session.commit()
        return jsonify({"Status": "Success"}),200

    except:
        session.rollback()
        return jsonify({"Status": "Failure"}), 500
    

@bp.route('/esami/elimina', methods=['DELETE'])
@jwt_required()
def elimina_esame():
    try:
        current_user = get_jwt_identity()
        if current_user['role'] == 'Studente':
            return jsonify({"Error":"Not Allowed"}), 403

        idesame = request.json["idesame"]

        if not idesame:
            return jsonify({"Error":"Missing parameters!"}), 400

        session.query(Esame).filter(Esame.idesame == idesame).delete()
        session.commit()
        return jsonify({"Status": "Success"}),200
    except Exception as e:
        session.rollback()
        return jsonify({"Status": "Internal Server Error"}), 500
    

@bp.route('/esami', methods=['GET'])
@jwt_required()
def visualizza_esame():
    current_user = get_jwt_identity()
    if current_user['role'] == 'Studente':
        return jsonify({"Error":"Not Allowed"}), 403
    
    subquery = session.query(Realizza.idesame).filter(Realizza.email == current_user['email'])
    esami = session.query(Esame).filter(Esame.idesame.in_(subquery))

    result = []
    for esame in esami:
        prove = session.query(Prova).filter(Prova.idesame == esame.idesame)

        lista_prove = []
        for prova in prove:
            lista_prove.append({
                "idprova" : prova.idprova,
                "tipologia" : prova.tipologia,
                "opzionale" : "true",
                "datascadenza" : prova.datascadenza,
                "dipendeda" : prova.dipendeda 
            })

        result.append({
            "idesame" : esame.idesame,
            "nome" : esame.nome,
            "crediti" : esame.crediti,
            "anno" : esame.anno,
            "prove" : lista_prove
        })

    return jsonify(result), 200