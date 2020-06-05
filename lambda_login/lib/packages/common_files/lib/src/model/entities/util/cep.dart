import 'dart:convert';

class Cep {
    String cep;
    String logradouro;
    String complemento;
    String bairro;
    String localidade;
    String uf;
    String unidade;
    String ibge;
    String gia;

    Cep({
        this.cep,
        this.logradouro,
        this.complemento,
        this.bairro,
        this.localidade,
        this.uf,
        this.unidade,
        this.ibge,
        this.gia,
    });

    factory Cep.fromJson(String str) => Cep.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory Cep.fromMap(Map<String, dynamic> json) => Cep(
        cep: json["cep"],
        logradouro: json["logradouro"],
        complemento: json["complemento"],
        bairro: json["bairro"],
        localidade: json["localidade"],
        uf: json["uf"],
        unidade: json["unidade"],
        ibge: json["ibge"],
        gia: json["gia"],
    );

    Map<String, dynamic> toMap() => {
        "cep": cep,
        "logradouro": logradouro,
        "complemento": complemento,
        "bairro": bairro,
        "localidade": localidade,
        "uf": uf,
        "unidade": unidade,
        "ibge": ibge,
        "gia": gia,
    };
}