from app.api import bp 
from app.extensions import session
from flask import jsonify, request
from flask_jwt_extended import *
from sqlalchemy import update
from sqlalchemy.exc import SQLAlchemyError, DataError

from app.models.Iscrizione import Iscrizione
from app.models.Studente import Studente
from app.models.Appello import Appello
from app.models.Prova import Prova

@bp.route('/iscrizioni/<idprova>/<data>')
@jwt_required()
def get_iscritti(idprova=None, data=None):
    try:
        current_user = get_jwt_identity()
        if current_user['role'] == 'Studente':
            return jsonify({"Error":"Not Allowed"}), 403
        
        appello = session.query(Appello) \
            .filter(Appello.idprova == idprova) \
            .filter(Appello.data == data) \
            .first() 

        if not appello:
            return jsonify({"Error": "Nessun Appello Trovato"}), 404

        subquery = session.query(Iscrizione.email) \
            .filter(Iscrizione.idappello == appello.idappello) \
            .filter(Iscrizione.voto == None)

        query = session.query(Studente.nome, Studente.cognome, Studente.email) \
            .filter(Studente.email.in_(subquery)) \
            .all()

        result = []
        for record in query:
            result.append({
                'nome' : record.nome, 
                'cognome' : record.cognome,
                'email' : record.email,
            })
        if not result:
            return jsonify({"Error": "No Data Found"}), 404

        return jsonify(result), 200
    
    except DataError:
        session.rollback()
        return jsonify({"Error": "Invalid data format or type"}), 400  # 400 - Bad Request
    except SQLAlchemyError as e:
        session.rollback()
        return jsonify({"Error": "Database error"}), 500
    except Exception as e:
        return jsonify({"error": "Something went wrong"}), 500
    

@bp.route('/iscrizioni/<idprova>/<data>/voto', methods=['POST'])
@jwt_required()
def inserisci_voto(idprova, data):
    try:
        current_user = get_jwt_identity()
        if current_user['role'] == 'Studente':
            return jsonify({"Error":"Not Allowed"}), 403
        
        responsabile = session.query(Prova).filter(Prova.idprova == idprova).first()

        if responsabile.responsabile != current_user['email']:
            return jsonify({"Error":f"Not Allowed to modify grades for {idprova}"}), 403

        stud_email = request.json['stud_email']
        voto = None
        bonus = None
        idoneita = True

        if "voto" in request.json:
            voto = request.json['voto']
            if int(voto) >= 18:
                idoneita = True
            else:
                idoneita = False
        elif "bonus" in request.json:
            bonus = request.json['bonus']
        elif "idoneita" in request.json:
            idoneita = request.json['idoneita']

        appello = session.query(Appello) \
                .filter(Appello.idprova == idprova) \
                .filter(Appello.data == data) \
                .first() 

        query = update(Iscrizione) \
            .filter(Iscrizione.idappello == appello.idappello) \
            .filter(Iscrizione.email == stud_email) \
            .values(
                voto = voto,
                bonus = bonus,
                idoneita = idoneita 
            )

        session.execute(query)
        session.commit()
        
        return jsonify({"Status":"Success"})
    
    except DataError:
        session.rollback()
        return jsonify({"Error": "Invalid data format or type"}), 400  # 400 - Bad Request
    except SQLAlchemyError as e:
        session.rollback()
        return jsonify({"Error": "Database error"}), 500
    except Exception as e:
        session.rollback()
        return jsonify({"Error":"Internal Server Error"}), 500
