import 'package:flutter/foundation.dart';
enum FilterEhSincronizado {todos, sincronizados, naoSincronizados}
enum FilterEhCancelado {todos, cancelados, naoCancelados}
enum FilterEhDeletado {todos, deletados, naoDeletados}
enum TipoLogin {facebookLogin, googleLogin, emailLogin}
enum StatusSincronizacao {finalizada, erro}
enum StatusLogin {loginOk, usuarioSenhaInvalida, usuarioJaCadastrado, usuarioBloqueado, semConexao}
enum StatusCaixa {aberto, fechado, necessitaAbertura, caixaDoDiaAnteriorAberto}
enum TipoMovimentoCaixa {abertura, fechamento, retirada, reforco, sangria}
enum TipoAtualizacaoEstoque {ignorar, subtrair, sobrepor, somar}
enum TipoApresentacaoProduto {grid, list}
enum TipoImpressora {bluetooth, rede}
enum FilterTemServico {todos, naoServico, ehServico}
enum PeriodoRelatorio {hoje, ontem, semana_atual, semana_anterior, mes_atual, mes_anterior, ano_atual, ano_anterior, selecione}
enum FilterEhAtivo {todos, ativos, naoAtivos}
enum FilterEhDemonstracao {todos, demonstracao, naoDemonstracao}
const Map<String, dynamic> lambdaHeaders = {"Content-Type" : 'application/json', 'accept': '*/*', "cache-control": "no-cache"};
const int queryLimit = 15;
const String zenDeskAccountKey = "qolnonfukw7Ka8RHogUgSwNPEB884kSQ";
const String accessKeyId = 'AKIAJ4EUQPYS24CB35GA';
const String secretKeyId = 'D8/qdMHWqQmflMtXScwXevg5F79mvmwQ92XE91Rd';
const String region = 'sa-east-1';
const String s3Endpoint = 'https://fluggy-images.s3-sa-east-1.amazonaws.com';
const String lambdaEndpoint = "https://535uyq7s8d.execute-api.sa-east-1.amazonaws.com/prod/";
const String databaseName = 'database.db';
const String facebookGrapQLUrl = "https://graph.facebook.com/me";
final String hasuraUrl = kReleaseMode ? "https://testeapp.neopdv.com.br/v1/graphql" : "http://ec2-54-233-64-9.sa-east-1.compute.amazonaws.com:8080/v1/graphql";
final String postgresUrl = "graphqldb.clb0ejaw4ykt.sa-east-1.rds.amazonaws.com";
final String postgresUsername = "zumaadmin";
final String postgresPassword = "newappzuma2211";
final String postgresDatabase = "postgres";
