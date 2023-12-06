from app.api import bp 
from app.extensions import session
from flask import jsonify, request
from flask_jwt_extended import *
from sqlalchemy import insert

from app.models.Libretto import Libretto
from app.models.Esame import Esame
from app.models.Appello import Appello
from app.models.Iscrizione import Iscrizione
import sys
@bp.route('/libretto', methods=['GET'])
@jwt_required()
def get_libretto():
    try:
        current_user = get_jwt_identity()
        if current_user['role'] == 'Docente':
            return jsonify({"Error":"Not Allowed"}), 403
        
        query = session.query(Libretto.votocomplessivo, Esame.nome, Esame.crediti, Esame.anno, Esame.idesame) \
            .join(Esame) \
            .filter(Libretto.email == current_user['email']) \
            .all()

        data = session.query(Appello.data) \
            .join(Iscrizione) \
            .filter(Iscrizione.idoneita == True) \
            .filter(Iscrizione.voto != None).first()

        result = []
        for record in query:
            result.append({
                'nome' : record.nome, 
                'voto_complessivo' : record.votocomplessivo,
                'crediti' : record.crediti,
                'anno' : record.anno,
                'data' : data.data
            })

        return jsonify(result), 200
    except:
        return jsonify({"Error":"Internal Server Error"}), 500

    
