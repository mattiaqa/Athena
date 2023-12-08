from app.api import bp 
from app.extensions import session
from flask import jsonify, request
from flask_jwt_extended import *

from app.models.Studente import Studente
from app.models.Docente import Docente

@bp.route('/utente/data', methods=['GET'])
@jwt_required()
def get_user_data():
    current_user = get_jwt_identity()
    tipo = current_user['role']
    
    result = []
    if tipo == 'Studente':
        query = session.query(Studente.nome, Studente.cognome, Studente.email, Studente.datanascita, Studente.matricola, Studente.facolta) \
            .filter(Studente.email == current_user['email']) \
            .all()
    else:
        query = session.query(Docente.nome, Docente.cognome, Docente.email, Docente.datanascita) \
            .filter(Docente.email == current_user['email']) \
            .all()
        
    result = []
    for record in query:
        result.append({
            'nome' : record.nome, 
            'cognome' : record.cognome,
            'email' : record.email,
            'datanascita' : str(record.datanascita),
            'facolta': record.facolta if tipo == 'Studente' else None, 
            'matricola': record.matricola if tipo == 'Studente' else None, 
            'role' : tipo
        })

    if not result:
        return jsonify({"Error":"No data found"}), 404
    return jsonify(result), 200