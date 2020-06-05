import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:isolate';
import 'package:common_files/common_files.dart';
import 'package:common_files/src/model/entities/operacao/sincronizacao/sincronizacao.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path_;


class SincronizacaoHasura {
  HasuraBloc _hasuraBloc;
  SharedVendaBloc _vendaBloc;
  AppGlobalBloc _appGlobalBloc;
  DateTime _ultSincronizacao = DateTime.parse("2019-09-13T20:54:31.951813");
  String _ultSincronizacaoCategoria = "2019-09-13T20:54:31.951813";
  String _ultSincronizacaoProduto = "2019-09-13T20:54:31.951813";

  SincronizacaoHasura(this._hasuraBloc, this._vendaBloc, this._appGlobalBloc){}
  
  getSincronizacaoFromServer() async {
    print("**** getSincronizacaoFromServer - INICIO - ult sinc: ${_ultSincronizacao.toString()} ****");
    String _query = """
      subscription getSincronizacao(\$sinc: timestamp!) {
        sincronizacao(order_by: {data_atualizacao: desc}, where: {data_atualizacao: {_gt: \$sinc}}) {
          id
          id_pessoa_grupo
          tabela
          data_atualizacao
        }
      }
    """;

    var snap = await _hasuraBloc.hasuraConnect.subscription(_query, variables: {"sinc": "${_ultSincronizacao.toString()}"}).map((data) =>
          (data["data"]["sincronizacao"] as List)
              .map((d) => Sincronizacao.fromJson(d))
              .toList());

      snap.stream.listen((data) async {
        if (data.length > 0) {
          for (Sincronizacao sincronizacao in data) {
            print("sincronizacao: "+sincronizacao.dataAtualizacao.toString());
            //await syncPessoaGrupo();
            //await syncAplicativo();
            //await syncAplicativoVersao();
            await syncPessoa();
            await syncModulo();
            await syncModuloGrupo();
            await syncPessoaModulo();
            await syncTipoPagamento();
            await syncTransacao();
            await syncTerminal();
            await syncTerminalImpressora();
            await syncCategoria();
            await syncGrade();
            await syncVariante();
            await syncProduto();
            await syncConfiguracaoPessoa();
            //Deixar ConfiguraçãoGeral por ultimo (SEMPRE)
            await syncConfiguracaoGeral();
            _ultSincronizacao = sincronizacao.dataAtualizacao;
          }
          print("_ultSincronizacao: "+_ultSincronizacao.toString());
          snap.changeVariable({"sinc": "$_ultSincronizacao"});
        }  
        this._vendaBloc.updateSincronizacaoHasuraStream(StatusSincronizacao.finalizada);
      }).onError((err) {
        print(err);
        this._vendaBloc.updateSincronizacaoHasuraStream(StatusSincronizacao.erro);
      });    
  }
  
  syncAplicativo() async {
    print("syncAplicativo: --- INICIO ---");
    DateTime _data;
    bool endSync = false;
    while (!endSync) {
      Aplicativo _aplicativo = Aplicativo();
      AplicativoDAO _aplicativoDAO = AplicativoDAO(_hasuraBloc, _appGlobalBloc, aplicativo: _aplicativo);
      List<Aplicativo> aplicativoList = [];
      _data = await _aplicativoDAO.getUltimaSincronizacao();
      print("_data: "+_data.toString());
      aplicativoList = await _aplicativoDAO.getAllFromServer(
        completo: true,
        filtroDataAtualizacao: _data
      );
      _aplicativo = null;
      _aplicativoDAO = null;
      try {
        print("<syncAplicativo> aplicativoList.length: "+aplicativoList.length.toString());
        if (aplicativoList.length > 0) {
          for (Aplicativo aplicativo in aplicativoList) {
            print("aplicativo: "+aplicativo.nome);
            AplicativoDAO aplicativoDAO = AplicativoDAO(_hasuraBloc, _appGlobalBloc, aplicativo: aplicativo);
            await aplicativoDAO.insert();
            aplicativo = null;
            aplicativoDAO = null;
          }
        } else {
          print("endSync");
          endSync = true;
        }
        aplicativoList = null; 
      } catch (error) {
        print(error);
      } 
    }  
    print("syncAplicativo: --- FIM ---");
  }

  syncAplicativoVersao() async {
    print("syncAplicativoVersao: --- INICIO ---");
    DateTime _data;
    bool endSync = false;
    while (!endSync) {
      AplicativoVersao _aplicativoVersao = AplicativoVersao();
      AplicativoVersaoDAO _aplicativoVersaoDAO = AplicativoVersaoDAO(_hasuraBloc, _appGlobalBloc, aplicativoVersao: _aplicativoVersao);
      List<AplicativoVersao> aplicativoVersaoList = [];
      _data = await _aplicativoVersaoDAO.getUltimaSincronizacao();
      print("_data: "+_data.toString());
      aplicativoVersaoList = await _aplicativoVersaoDAO.getAllFromServer(
        completo: true,
        filtroDataAtualizacao: _data
      );
      _aplicativoVersao = null;
      _aplicativoVersaoDAO = null;
      try {
        print("<syncAplicativoVersao> aplicativoVersaoList.length: "+aplicativoVersaoList.length.toString());
        if (aplicativoVersaoList.length > 0) {
          for (AplicativoVersao aplicativoVersao in aplicativoVersaoList) {
            print("aplicativoVersao: "+aplicativoVersao.versao);
            AplicativoVersaoDAO aplicativoVersaoDAO = AplicativoVersaoDAO(_hasuraBloc, _appGlobalBloc, aplicativoVersao: aplicativoVersao);
            await aplicativoVersaoDAO.insert();
            aplicativoVersao = null;
            aplicativoVersaoDAO = null;
          }
        } else {
          print("endSync");
          endSync = true;
        }
        aplicativoVersaoList = null; 
      } catch (error) {
        print(error);
      } 
    }  
    print("syncAplicativoVersao: --- FIM ---");
  }  

  syncPessoaGrupo() async {
    print("syncPessoaGrupo: --- INICIO ---");
    DateTime _data;
    bool endSync = false;
    while (!endSync) {
      PessoaGrupo _pessoaGrupo = PessoaGrupo();
      PessoaGrupoDAO _pessoaGrupoDAO = PessoaGrupoDAO(_hasuraBloc, _appGlobalBloc, _pessoaGrupo);
      List<PessoaGrupo> pessoaGrupoList = [];
      _data = await _pessoaGrupoDAO.getUltimaSincronizacao();
      print("_data: "+_data.toString());
      pessoaGrupoList = await _pessoaGrupoDAO.getAllFromServer(
        id: true,
        idPessoa: true,
        ehDeletado: true,
        dataCadastro: true,
        dataAtualizacao: true,
        filtroDataAtualizacao: _data
      );
      _pessoaGrupo = null;
      _pessoaGrupoDAO = null;
      try {
        print("<syncPessoaGrupo> pessoaGrupoList.length: "+pessoaGrupoList.length.toString());
        if (pessoaGrupoList.length > 0) {
          for (PessoaGrupo pessoaGrupo in pessoaGrupoList) {
            print("pessoaGrupo: "+pessoaGrupo.nome);
            PessoaGrupoDAO pessoaGrupoDAO = PessoaGrupoDAO(_hasuraBloc, _appGlobalBloc, pessoaGrupo);
            await pessoaGrupoDAO.insert();
            pessoaGrupo = null;
            pessoaGrupoDAO = null;
          }
        } else {
          print("endSync");
          endSync = true;
        }
        pessoaGrupoList = null; 
      } catch (error) {
        print(error);
      } 
    }  
    print("syncPessoaGrupo: --- FIM ---");
  }

  syncPessoa() async {
    print("syncPessoa: --- INICIO ---");
    DateTime _data;
    bool endSync = false;
    while (!endSync) {
      Pessoa _pessoa = Pessoa();
      PessoaDAO _pessoaDAO = PessoaDAO(_hasuraBloc, _appGlobalBloc, _pessoa);
      List<Pessoa> pessoaList = [];
      _data = await _pessoaDAO.getUltimaSincronizacao();
      print("_data: "+_data.toString());
      pessoaList = await _pessoaDAO.getAllFromServer(
        completo: true,
        filtroDataAtualizacao: _data
      );
      _pessoa = null;
      _pessoaDAO = null;
      try {
        print("<syncPessoa> pessoaList.length: "+pessoaList.length.toString());
        if (pessoaList.length > 0) {
          for (Pessoa pessoa in pessoaList) {
            print("pessoa: "+pessoa.fantasiaApelido);
            PessoaDAO pessoaDAO = PessoaDAO(_hasuraBloc, _appGlobalBloc, pessoa);
            await pessoaDAO.insert();
            pessoa = null;
            pessoaDAO = null;
          }
        } else {
          print("endSync");
          endSync = true;
        }
        pessoaList = null; 
      } catch (error) {
        print(error);
      } 
    }  
    print("syncPessoa: --- FIM ---");
  }

  syncModulo() async {
    print("syncModulo: --- INICIO ---");
    DateTime _data;
    bool endSync = false;
    while (!endSync) {
      Modulo _modulo = Modulo();
      ModuloDAO _moduloDAO = ModuloDAO(_hasuraBloc, _appGlobalBloc, _modulo);
      List<Modulo> moduloList = [];
      _data = await _moduloDAO.getUltimaSincronizacao();
      print("_data: "+_data.toString());
      try {
        moduloList = await _moduloDAO.getAllFromServer(
          completo: true,
          filtroDataAtualizacao: _data
        );
        _modulo = null;
        _moduloDAO = null;
   
        print("<syncModulo> moduloList.length: "+moduloList.length.toString());
        if (moduloList.length > 0) {
          for (Modulo modulo in moduloList) {
            print("modulo: "+modulo.nome);
            ModuloDAO moduloDAO = ModuloDAO(_hasuraBloc, _appGlobalBloc, modulo);
            await moduloDAO.insert();
            modulo = null;
            moduloDAO = null;
          }
        } else {
          print("endSync");
          endSync = true;
        }
        moduloList = null; 
      } catch (error) {
        print(error);
      } 
    }  
    print("syncModulo: --- FIM ---");
  }

  syncModuloGrupo() async {
    print("syncModuloGrupo: --- INICIO ---");
    DateTime _data;
    bool endSync = false;
    while (!endSync) {
      ModuloGrupo _moduloGrupo = ModuloGrupo();
      ModuloGrupoDAO _moduloGrupoDAO = ModuloGrupoDAO(_hasuraBloc, _appGlobalBloc, _moduloGrupo);
      List<ModuloGrupo> moduloGrupoList = [];
      _data = await _moduloGrupoDAO.getUltimaSincronizacao();
      print("_data: "+_data.toString());
      moduloGrupoList = await _moduloGrupoDAO.getAllFromServer(
        preLoad: true,
        completo: true,
        filtroDataAtualizacao: _data
      );
      _moduloGrupo = null;
      _moduloGrupoDAO = null;
      try {
        print("<syncModuloGrupo> moduloGrupoList.length: "+moduloGrupoList.length.toString());
        if (moduloGrupoList.length > 0) {
          for (ModuloGrupo moduloGrupo in moduloGrupoList) {
            print("moduloGrupo: "+moduloGrupo.nome);
            ModuloGrupoDAO moduloGrupoDAO = ModuloGrupoDAO(_hasuraBloc, _appGlobalBloc, moduloGrupo);
            await moduloGrupoDAO.insert();
            moduloGrupo = null;
            moduloGrupoDAO = null;
          }
        } else {
          print("endSync");
          endSync = true;
        }
        moduloGrupoList = null; 
      } catch (error) {
        print(error);
      } 
    }  
    print("syncModuloGrupo: --- FIM ---");
  }

  syncPessoaModulo() async {
    print("syncPessoaModulo: --- INICIO ---");
    DateTime _data;
    bool endSync = false;
    while (!endSync) {
      PessoaModulo _pessoaModulo = PessoaModulo();
      PessoaModuloDAO _pessoaModuloDAO = PessoaModuloDAO(_hasuraBloc, _appGlobalBloc, pessoaModulo: _pessoaModulo);
      List<PessoaModulo> pessoaModuloList = [];
      _data = await _pessoaModuloDAO.getUltimaSincronizacao();
      print("_data: "+_data.toString());
      pessoaModuloList = await _pessoaModuloDAO.getAllFromServer(
        completo: true,
        filtroDataAtualizacao: _data
      );
      _pessoaModulo = null;
      _pessoaModuloDAO = null;
      try {
        print("<syncPessoaModulo> pessoaModuloList.length: "+pessoaModuloList.length.toString());
        if (pessoaModuloList.length > 0) {
          for (PessoaModulo pessoaModulo in pessoaModuloList) {
            print("pessoaModulo: "+pessoaModulo.id.toString());
            PessoaModuloDAO pessoaModuloDAO = PessoaModuloDAO(_hasuraBloc, _appGlobalBloc, pessoaModulo: pessoaModulo);
            await pessoaModuloDAO.insert();
            pessoaModulo = null;
            pessoaModuloDAO = null;
          }
        } else {
          print("endSync");
          endSync = true;
        }
        pessoaModuloList = null; 
      } catch (error) {
        print(error);
      } 
    }  
    print("syncPessoaModulo: --- FIM ---");
  }

  syncTipoPagamento() async {
    print("syncTipoPagamento: --- INICIO ---");
    DateTime _data;
    bool endSync = false;
    while (!endSync) {
      TipoPagamento _tipoPagamento = TipoPagamento();
      TipoPagamentoDAO _tipoPagamentoDAO = TipoPagamentoDAO(_hasuraBloc, _appGlobalBloc, tipoPagamento: _tipoPagamento);
      List<TipoPagamento> tipoPagamentoList = [];
      _data = await _tipoPagamentoDAO.getUltimaSincronizacao();
      print("_data: "+_data.toString());
      tipoPagamentoList = await _tipoPagamentoDAO.getAllFromServer(
        id: true,
        idPessoaGrupo: true,
        icone: true,
        ehDeletado: true,
        ehDinheiro: true,
        ehFiado: true,
        ehQrcode: true,
        dataCadastro: true,
        dataAtualizacao: true,
        filtroDataAtualizacao: _data
      );
      _tipoPagamento = null;
      _tipoPagamentoDAO = null;
      try {
        print("<syncTipoPagamento> tipoPagamentoList.length: "+tipoPagamentoList.length.toString());
        if (tipoPagamentoList.length > 0) {
          for (TipoPagamento tipoPagamento in tipoPagamentoList) {
            print("tipoPagamento: "+tipoPagamento.nome);
            TipoPagamentoDAO tipoPagamentoDAO = TipoPagamentoDAO(_hasuraBloc, _appGlobalBloc, tipoPagamento: tipoPagamento);
            await tipoPagamentoDAO.insert();
            Response response = await Dio().get('$s3Endpoint/${tipoPagamento.icone}',
            options: Options(
              responseType: ResponseType.bytes
            ));
            _writeTipoPagamentoBase64Image(content: base64.encode(response.data), tipoPagamento: tipoPagamento);
            tipoPagamento = null;
            tipoPagamentoDAO = null;
          }
        } else {
          print("endSync");
          endSync = true;
        }
        tipoPagamentoList = null; 
      } catch (error) {
        print(error);
      } 
    }  
    print("syncTipoPagamento: --- FIM ---");
  }

  _writeTipoPagamentoBase64Image({@required String content, @required TipoPagamento tipoPagamento}) async {
    final path = (await getApplicationDocumentsDirectory()).path;
    Directory directory = Directory("$path/images/tipoPagamento/${tipoPagamento.idPessoaGrupo}");
    await directory.create(recursive: true);
    if(await directory.exists()){
      final file = File("${directory.path}/${tipoPagamento.id}.txt");
      await file.writeAsString(content);
    }
  }

  syncTransacao() async {
    print("syncTransacao: --- INICIO ---");
    DateTime _data;
    bool endSync = false;
    while (!endSync) {
      Transacao _transacao = Transacao();
      TransacaoDAO _transacaoDAO = TransacaoDAO(_hasuraBloc, _transacao, _appGlobalBloc);
      List<Transacao> transacaoList = [];
      _data = await _transacaoDAO.getUltimaSincronizacao();
      print("_data: "+_data.toString());
      transacaoList = await _transacaoDAO.getAllFromServer(
        id: true,
        idPessoaGrupo: true,
        tipoEstoque: true,
        temPagamento: true,
        temCliente: true,
        temVendedor: true,
        descontoPercentual: true,
        idPrecoTabela: true,
        ehDeletado: true,
        dataCadastro: true,
        dataAtualizacao: true,
        filtroDataAtualizacao: _data
      );
      _transacao = null;
      _transacaoDAO = null;
      try {
        print("<syncTransacao> transacaoList.length: "+transacaoList.length.toString());
        if (transacaoList.length > 0) {
          for (Transacao transacao in transacaoList) {
            print("transacao: "+transacao.nome);
            TransacaoDAO transacaoDAO = TransacaoDAO(_hasuraBloc, transacao, _appGlobalBloc);
            await transacaoDAO.insert();
            transacao = null;
            transacaoDAO = null;
          }
        } else {
          print("endSync");
          endSync = true;
        }
        transacaoList = null; 
      } catch (error) {
        print(error);
      } 
    }  
    print("syncTransacao: --- FIM ---");
  }

  syncTerminal() async {
    print("syncTerminal: --- INICIO ---");
    DateTime _data;
    bool endSync = false;
    while (!endSync) {
      Terminal _terminal = Terminal();
      TerminalDAO _terminalDAO = TerminalDAO(_hasuraBloc, _appGlobalBloc, terminal: _terminal);
      List<Terminal> terminalList = [];
      _data = await _terminalDAO.getUltimaSincronizacao();
      print("_data: "+_data.toString());
      terminalList = await _terminalDAO.getAllFromServer(
        id: true,
        idPessoa: true,
        idTransacao: true,
        idDevice: true,
        ehDeletado: true,
        dataCadastro: true,
        dataAtualizacao: true,
        
        filtroDataAtualizacao: _data
      );
      _terminal = null;
      _terminalDAO = null;
      try {
        print("<syncTerminal> terminalList.length: "+terminalList.length.toString());
        if (terminalList.length > 0) {
          for (Terminal terminal in terminalList) {
            print("terminal: "+terminal.nome);
            TerminalDAO terminalDAO = TerminalDAO(_hasuraBloc, _appGlobalBloc, terminal: terminal);
            await terminalDAO.insert();
            terminal = null;
            terminalDAO = null;
          }
        } else {
          print("endSync");
          endSync = true;
        }
        terminalList = null; 
      } catch (error) {
        print(error);
      } 
    }  
    print("syncTerminal: --- FIM ---");
  }

  syncTerminalImpressora() async {
    print("syncTerminalImpressora: --- INICIO ---");
    DateTime _data;
    bool endSync = false;
    while (!endSync) {
      TerminalImpressora _terminalImpressora = TerminalImpressora();
      TerminalImpressoraDAO _terminalImpressoraDAO = TerminalImpressoraDAO(_hasuraBloc, _terminalImpressora, _appGlobalBloc);
      List<TerminalImpressora> terminalImpressoraList = [];
      _data = await _terminalImpressoraDAO.getUltimaSincronizacao();
      print("_data: "+_data.toString());
      terminalImpressoraList = await _terminalImpressoraDAO.getAllFromServer(
        id: true,
        idPessoa: true,
        idCupomLayout: true,
        idTerminal: true,
        ip: true,
        macAddress: true,
        tipoImpressora: true,
        ehDeletado: true,
        dataCadastro: true,
        dataAtualizacao: true,
        filtroDataAtualizacao: _data
      );
      _terminalImpressora = null;
      _terminalImpressoraDAO = null;
      try {
        print("<syncTerminalImpressora> terminalImpressoraList.length: "+terminalImpressoraList.length.toString());
        if (terminalImpressoraList.length > 0) {
          for (TerminalImpressora terminalImpressora in terminalImpressoraList) {
            print("terminalImpressora: "+terminalImpressora.nome);
            TerminalImpressoraDAO terminalImpressoraDAO = TerminalImpressoraDAO(_hasuraBloc, terminalImpressora, _appGlobalBloc);
            await terminalImpressoraDAO.insert();
            terminalImpressora = null;
            terminalImpressoraDAO = null;
          }
        } else {
          print("endSync");
          endSync = true;
        }
        terminalImpressoraList = null; 
      } catch (error) {
        print(error);
      } 
    }  
    print("syncTerminalImpressora: --- FIM ---");
  }

  syncCategoria() async {
    print("syncGrade: --- INICIO ---");
    DateTime _data;
    bool endSync = false;
    while (!endSync) {
      Categoria _categoria = Categoria();
      CategoriaDAO _categoriaDAO = CategoriaDAO(_hasuraBloc, _appGlobalBloc, categoria: _categoria);
      List<Categoria> categoriaList = [];
      _data = await _categoriaDAO.getUltimaSincronizacao();
      categoriaList = await _categoriaDAO.getAllFromServer(
        id: true,
        idPessoaGrupo: true,
        ehDeletado: true,
        ehServico: true,
        dataCadastro: true,
        dataAtualizacao: true,
        filtroDataAtualizacao: _data
      );
      _categoria = null;
      _categoriaDAO = null;
      try {
        print("<syncCategoria> categoriaList.length: "+categoriaList.length.toString());
        if (categoriaList.length > 0) {
          for (Categoria categoria in categoriaList) {
            print("categoria: "+categoria.toString());
            CategoriaDAO categoriaDAO = CategoriaDAO(_hasuraBloc, _appGlobalBloc, categoria: categoria);
            categoriaDAO.insert();
            categoria = null;
            categoriaDAO = null;
          }
          _vendaBloc.getallCategoria();
        } else {
          endSync = true;
        }  
        categoriaList = null; 
      } catch (error) {
        print(error);
      }  
    }
    print("syncGrade: --- FIM ---");
  }  

  syncGrade() async {
    print("syncGrade: --- INICIO ---");
    DateTime _data;
    bool endSync = false;
    while (!endSync) {
      Grade _grade = Grade();
      GradeDAO _gradeDAO = GradeDAO(_hasuraBloc, _appGlobalBloc, grade: _grade);
      List<Grade> gradeList = [];
      _data = await _gradeDAO.getUltimaSincronizacao();
      gradeList = await _gradeDAO.getAllFromServer(
        id: true,
        idPessoaGrupo: true,
        tamanhos: true,
        ehDeletado: true,
        dataCadastro: true,
        dataAtualizacao: true,
        filtroDataAtualizacao: _data
      );
      _grade = null;
      _gradeDAO = null;
      try {
        print("<syncGrade> gradeList.length: "+gradeList.length.toString());
        if (gradeList.length > 0) {
          for (Grade grade in gradeList) {
            print("grade: "+grade.nome);
            GradeDAO gradeDAO = GradeDAO(_hasuraBloc, _appGlobalBloc, grade: grade);
            await gradeDAO.insert();
            grade = null;
            gradeDAO = null;
          }
        } else {
          endSync = true;
        }
        gradeList = null; 
      } catch (error) {
        print(error);
      }  
    }  
    print("syncGrade: --- FIM ---");
  }

  syncVariante() async {
    print("syncVariante: --- INICIO ---");
    DateTime _data;
    bool endSync = false;
    while (!endSync) {
      Variante _variante = Variante();
      VarianteDAO _varianteDAO = VarianteDAO(_hasuraBloc, _appGlobalBloc, variante: _variante);
      List<Variante> varianteList = [];
      _data = await _varianteDAO.getUltimaSincronizacao();
      varianteList = await _varianteDAO.getAllFromServer(
        id: true,
        idPessoaGrupo: true,
        iconeCor: true,
        temImagem: true,
        ehDeletado: true,
        dataCadastro: true,
        dataAtualizacao: true,
        filtroDataAtualizacao: _data
      );
      _variante = null;
      _varianteDAO = null;
      try {
        print("<syncVariante> varianteList.length: "+varianteList.length.toString());
        if (varianteList.length > 0) {
          for (Variante variante in varianteList) {
            print("variante: "+variante.nome);
            VarianteDAO varianteDAO = VarianteDAO(_hasuraBloc, _appGlobalBloc, variante: variante);
            await varianteDAO.insert();
            variante = null;
            varianteDAO = null;
          }
        } else {
          endSync = true;
        }
        varianteList = null; 
      } catch (error) {
        print(error);
      }  
    }  
    print("syncVariante: --- FIM ---");
  }

  syncProduto() async {
    print("syncProduto: --- INICIO --- ");
    DateTime _data;
    bool endSync = false;
    while (!endSync) {
      Produto _produto = Produto();
      ProdutoDAO _produtoDAO = ProdutoDAO(_hasuraBloc, _appGlobalBloc, _produto);
      List<Produto> produtoList = [];
      _data = await _produtoDAO.getUltimaSincronizacao();
      produtoList = await _produtoDAO.getAllFromServer(
        id: true,
        idAparente: true,
        idPessoaGrupo: true, 
        idCategoria: true,
        idGrade: true,
        precoCusto: true,
        ehAtivo: true,
        ehDeletado: true,
        ehServico: true,
        iconeCor: true,
        dataCadastro: true,
        dataAtualizacao: true,
        precoTabelaItem: true,
        produtoVariante: true,
        produtoImagem: true,
        produtoCodigoBarras: true,
        filtroDataAtualizacao: _data
      );
      _produto = null;
      _produtoDAO = null;
      try {
        print("syncProduto: produtoList.length = "+produtoList.length.toString());
        if (produtoList.length > 0) {
          print("antes for");
          for (Produto produto in produtoList) {
            print("for produto: "+produto.nome);
            ProdutoDAO produtoDAO = ProdutoDAO(_hasuraBloc, _appGlobalBloc, produto);
            await produtoDAO.insert();
            print("produto.produtoImagem.length: ${produto.produtoImagem.length.toString()}");
            if (produto.produtoImagem.length > 0) {
              print("pos _writeProdutoBase64Image");
              Response response = await Dio().get('$s3Endpoint${produto.produtoImagem.first.imagem}',
              options: Options(
                responseType: ResponseType.bytes
              ));
              _writeProdutoBase64Image(content: base64.encode(response.data), produto: produto);
              print("pos _writeProdutoBase64Image");
            }
          }
          _vendaBloc.offset = 0;
          _vendaBloc.getallProduto();
        } else {
          endSync = true;
        }
        produtoList = null;  
      } catch (error) {
        print(error);
      }  
    }  
  }

  syncConfiguracaoPessoa() async {
    print("syncConfiguracaoPessoa: --- INICIO --- ");
    DateTime _data;
    bool endSync = false;
    while (!endSync) {
      ConfiguracaoPessoa _configuracaoPessoa = ConfiguracaoPessoa();
      ConfiguracaoPessoaDAO _configuracaoPessoaDAO = ConfiguracaoPessoaDAO(_hasuraBloc, _configuracaoPessoa, _appGlobalBloc);
      List<ConfiguracaoPessoa> configuracaoPessoaList = [];
      _data = await _configuracaoPessoaDAO.getUltimaSincronizacao();
      print(_data.toIso8601String());
      configuracaoPessoaList = await _configuracaoPessoaDAO.getAllFromServer(
        id: true,
        idPessoa: true,
        textoCabecalho: true,
        textoRodape: true, 
        dataCadastro: true,
        dataAtualizacao: true,
        filtroDataAtualizacao: _data
      );
      _configuracaoPessoa = null;
      _configuracaoPessoaDAO = null;
      try {
        print("<syncConfiguracaoPessoa> configuracaoPessoaList.length: "+configuracaoPessoaList.length.toString());
        if (configuracaoPessoaList.length > 0) {
          for (ConfiguracaoPessoa configuracaoPessoa in configuracaoPessoaList) {
            ConfiguracaoPessoaDAO configuracaoPessoaDAO = ConfiguracaoPessoaDAO(_hasuraBloc, configuracaoPessoa, _appGlobalBloc);
            await configuracaoPessoaDAO.insert();
            configuracaoPessoa = null;
            configuracaoPessoaDAO = null;
          }
        } else {
          endSync = true;
        }
        configuracaoPessoaList = null; 
      }  catch (error) {
        print(error);
      }  
    }  
  }  

  syncConfiguracaoGeral() async {
    print("syncConfiguracaoGeral: --- INICIO --- ");
    DateTime _data;
    bool endSync = false;
    while (!endSync) {
      ConfiguracaoGeral _configuracaoGeral = ConfiguracaoGeral();
      ConfiguracaoGeralDAO _configuracaoGeralDAO = ConfiguracaoGeralDAO(_hasuraBloc, _configuracaoGeral, _appGlobalBloc);
      List<ConfiguracaoGeral> configuracaoGeralList = [];
      _data = await _configuracaoGeralDAO.getUltimaSincronizacao();
      configuracaoGeralList = await _configuracaoGeralDAO.getAllFromServer(
        id: true,
        idPessoaGrupo: true, 
        temServico: true,
        ehServicoDefault: true,
        ehMenuClassico: true,
        dataCadastro: true,
        dataAtualizacao: true,
        filtroDataAtualizacao: _data
      );
      _configuracaoGeral = null;
      _configuracaoGeralDAO = null;
      try {
        print("<syncConfiguracaoGeral> configuracaoGeralList.length: "+configuracaoGeralList.length.toString());
        if (configuracaoGeralList.length > 0) {
          for (ConfiguracaoGeral configuracaoGeral in configuracaoGeralList) {
            ConfiguracaoGeralDAO configuracaoGeralDAO = ConfiguracaoGeralDAO(_hasuraBloc, configuracaoGeral, _appGlobalBloc);
            await configuracaoGeralDAO.insert();
            configuracaoGeral = null;
            configuracaoGeralDAO = null;
          }
          _appGlobalBloc.getMenu();
        } else {
          endSync = true;
        }
        configuracaoGeralList = null; 
      }  catch (error) {
        print(error);
      }  
    }  
  }

  _writeProdutoBase64Image({@required String content, @required Produto produto}) async {
    print("dirname: "+path_.dirname(produto.produtoImagem.first.imagem));
    final path = (await getApplicationDocumentsDirectory()).path;//+ path_.dirname(produto.produtoImagem.first.imagem);
    Directory directory = Directory("$path${path_.dirname(produto.produtoImagem.first.imagem)}");
    await directory.create(recursive: true);
    if(await directory.exists()){
      final file = File("${path}${produto.produtoImagem.first.imagem.replaceAll(".png", "")}.txt");
      await file.writeAsString(content);
    }
  }

  getCategoriaListFromServer() async {
    DateTime dataSync;
    String _query = """
      subscription syncCategoria(\$sinc: timestamp!) {
        categoria(order_by: {data_atualizacao: desc}, where: {data_atualizacao: {_gt: \$sinc}}) {
          id
          id_pessoa_grupo
          nome
          data_cadastro
          data_atualizacao
        }
      }
    """;

    var snap = _hasuraBloc.hasuraConnect.subscription(_query, variables: {"sinc": "$_ultSincronizacaoCategoria"}).map((data) =>
          (data["data"]["categoria"] as List)
              .map((d) => Categoria.fromJson(d))
              .toList());

      snap.stream.listen((data) {
        if (data.length > 0) {
          for (Categoria categoria in data) {
            print("categoria: "+categoria.nome);
            CategoriaDAO categoriaDAO = CategoriaDAO(_hasuraBloc, _appGlobalBloc, categoria: categoria);
            categoriaDAO.insert();
            dataSync = categoria.dataAtualizacao;
          }
          _ultSincronizacaoCategoria = dataSync.toString();
          _vendaBloc.getallCategoria();
          snap.changeVariable({"sinc": "$_ultSincronizacaoCategoria"});
        }  
      }).onError((err) {
        print(err);
      });    
  }

  getProdutoListFromServer() async {
    DateTime dataSync;
    String _query = """
      subscription syncProduto(\$sinc: timestamp!) {
        produto(order_by: {data_atualizacao: asc}, where: {data_atualizacao: {_gt: \$sinc}}) {
          id
          id_pessoa_grupo
          id_aparente
          id_categoria
          id_grade
          nome
          preco_custo
          ehativo
          data_cadastro
          data_atualizacao
          produto_imagem {
            id
            id_produto
            imagem
          }
          preco_tabela_items {
            id
            id_preco_tabela
            id_produto
            preco
          }
          produto_variante {
            id
            id_produto
            id_variante
            ehdeletado
          }
        }
      }
    """;

    var snap = _hasuraBloc.hasuraConnect.subscription(_query, variables: {"sinc": "$_ultSincronizacaoProduto"}).map((data) =>
          (data["data"]["produto"] as List)
              .map((d) => Produto.fromJson(d))
              .toList());

      snap.stream.listen((data) {
        if (data.length > 0) {
          for (Produto produto in data) {
            print("produto: "+produto.nome);
            ProdutoDAO produtoDAO = ProdutoDAO(_hasuraBloc, _appGlobalBloc, produto);
            produtoDAO.insert();
            dataSync = produto.dataAtualizacao;
          }
          _ultSincronizacaoProduto = dataSync.toString();
          _vendaBloc.getallProduto();
          snap.changeVariable({"sinc": "$_ultSincronizacaoProduto"});
        }  
      }).onError((err) {
        print(err);
      });  
  }


  Isolate _isolate;
  bool running = false;
  static int _counterZ = 60;
  String notification = "";
  ReceivePort _receivePort;

  int get counterZ => _counterZ;
  set counterZ(int counterZ) => _counterZ = counterZ;

  void start() async {
    /*print('Started !!');
    running = true;
    _receivePort = ReceivePort();
    _isolate = await Isolate.spawn(_checkTimer, _receivePort.sendPort);
    _receivePort.listen(_handleMessage, onDone:() {
        print("done!");
    });*/
    //notifyListeners();      
  }

  static int getcounter(){
    return SincronizacaoHasura._counterZ;
  }

  static void incCouter(){
    _counterZ++;
  }

  static void setCouter(int value){
    _counterZ = value;
  }

  static void _checkTimer(SendPort sendPort, {bool stopThread = false}) async {
    _counterZ = 6000;
    var timer = Timer.periodic(new Duration(seconds: 1), (Timer t) {
      incCouter();
      if (getcounter() >= 6000) {
        String msg = 'EXECUTA SYNC';      
        print('SEND: ' + msg);
        sendPort.send(msg);
        setCouter(0);
      }
    });
  }

  _handleMessage(dynamic data) async {
    print('RECEIVED: ' + data);
    await syncMovimento();
    //notification = data;
    //notifyListeners();      
  }

  stop() async {
    if (_isolate != null) {
       running = false; 
       notification = '';   
      _receivePort.close();
      _isolate.kill(priority: Isolate.immediate);
      _isolate = null;        
      //notifyListeners();      
      }
  }

  syncMovimento() async {
    Movimento movimento = Movimento();
    List<Movimento> movimentoList;
    MovimentoDAO movimentoDAO = MovimentoDAO(_hasuraBloc, _appGlobalBloc, movimento);
    movimentoDAO.filterEhSincronizado = FilterEhSincronizado.naoSincronizados;
    movimentoDAO.loadMovimentoItem = true;
    movimentoDAO.loadMovimentoParcela = true;
    movimentoList = await movimentoDAO.getAll(preLoad: true);
        
    for (Movimento mov in movimentoList) {    
      
      /*String _queryItens = "";
      for (var i=0; i < mov.movimentoItem.length; i++){
        if (i == 0) {
          _queryItens = '{data: [';
        }  

        if ((mov.movimentoItem[i].id != null) && (mov.movimentoItem[i].id > 0)) {
          _queryItens = _queryItens + "{id: ${mov.movimentoItem[i].id},";
        } else {
          _queryItens = _queryItens + "{";
        }    

        _queryItens = _queryItens + 
          """
            id_app: ${mov.movimentoItem[i].idApp},
            id_produto: ${mov.movimentoItem[i].idProduto},
            id_variante: ${mov.movimentoItem[i].idVariante},
            grade_posicao: ${mov.movimentoItem[i].gradePosicao},
            sequencial: ${mov.movimentoItem[i].sequencial},
            quantidade: ${mov.movimentoItem[i].quantidade},
            preco_custo: ${mov.movimentoItem[i].precoCusto},
            preco_tabela: ${mov.movimentoItem[i].precoTabela},
            preco_vendido: ${mov.movimentoItem[i].precoVendido},
            total_liquido: ${mov.movimentoItem[i].totalLiquido},
            total_desconto: ${mov.movimentoItem[i].totalDesconto},
            data_cadastro: "${mov.movimentoItem[i].dataCadastro}",
            data_atualizacao: "${mov.movimentoItem[i].dataAtualizacao}" 
          }  
         """;
        if (i == mov.movimentoItem.length-1){
          _queryItens = _queryItens + 
            """],
                on_conflict: {
                  constraint: movimento_item_pkey, 
                  update_columns: [
                    quantidade,
                    preco_custo,
                    preco_tabela,
                    preco_vendido,
                    total_liquido,
                    total_desconto,
                    data_cadastro,
                    data_atualizacao
                  ]
                }
              }},
            """;
        }
      }

      mov.ehsincronizado = 1;
      String _query = """ mutation addMovimento {
          insert_movimento(objects: {""";
      if ((mov.id != null) && (mov.id > 0)) {
        _query = _query + "id: ${mov.id},";
      }    
      _query = _query +
        """
            id_app: ${mov.idApp}, 
            total_itens: ${mov.totalItens}, 
            total_quantidade: ${mov.totalQuantidade},
            valor_total_bruto: ${mov.valorTotalBruto},
            valor_total_desconto: ${mov.valorTotalDesconto},
            valor_total_liquido: ${mov.valorTotalLiquido}, 
            valor_troco: ${mov.valorTroco},
            ehcancelado: ${mov.ehcancelado},
            ehorcamento: ${mov.ehorcamento},
            ehsincronizado: ${mov.ehsincronizado},
            data_movimento: "${mov.dataMovimento}",
            data_fechamento: "${mov.dataFechamento}",
            data_atualizacao: "${mov.dataAtualizacao}",
            movimento_items: $_queryItens
            on_conflict: {
              constraint: movimento_pkey, 
              update_columns: [
                valor_total_bruto, 
                valor_total_liquido, 
                valor_total_desconto, 
                total_itens, 
                total_quantidade
              ]
            }) {
            returning {
              id
              movimento_items{
                id
                id_app
              }
            }
          }
        }  
      """;
      print(_query);
      try {
        var data = await _hasuraBloc.hasuraConnect.mutation(_query);
        mov.id = data["data"]["insert_movimento"]["returning"][0]["id"];
        for (var i = 0; i < mov.movimentoItem.length; i++) {
          mov.movimentoItem[i].id = data["data"]["insert_movimento"]["returning"][0]["movimento_items"][i]["id"];
          mov.movimentoItem[i].idMovimento = mov.id;
        }
        MovimentoDAO movDao = MovimentoDAO(mov);
         await movDao.insert();
        movDao = null;
      } catch (e) {
        print(e);
      }*/
      await chamaZuminha(mov: mov);
    }
    await _vendaBloc.getAllPedido();
  }

  void doSync() {
    setCouter(60);
  }

  Future chamaZuminha({Movimento mov}) async {
    String resource = mov.ehcancelado == 0 ? "grava-venda" : "cancela-venda";
    mov.ehsincronizado = 1;
    try {
      print(mov.toJson());
      var dio = Dio();
      var token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxIiwiaWRfcGVzc29hIjoxLCJpZF9wZXNzb2FfZ3J1cG8iOjEsIm5vbWUiOiJHdXN0YXZvIiwiYWRtaW4iOnRydWUsImh0dHBzOi8vaGFzdXJhLmlvL2p3dC9jbGFpbXMiOnsieC1oYXN1cmEtYWxsb3dlZC1yb2xlcyI6WyJ1c2VyIl0sIngtaGFzdXJhLWRlZmF1bHQtcm9sZSI6InVzZXIiLCJ4LWhhc3VyYS11c2VyLWlkIjoiMSIsIngtaGFzdXJhLW9yZy1pZCI6IjEifX0=.fWofmiSRa/y+L2a+y2BkbSoyxp7ls22uhhazQSy0nK0=|eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxIiwiaWRfcGVzc29hIjoxLCJpZF9wZXNzb2FfZ3J1cG8iOjEsIm5vbWUiOiJHdXN0YXZvIiwiYWRtaW4iOnRydWUsImh0dHBzOi8vaGFzdXJhLmlvL2p3dC9jbGFpbXMiOnsieC1oYXN1cmEtYWxsb3dlZC1yb2xlcyI6WyJ1c2VyIl0sIngtaGFzdXJhLWRlZmF1bHQtcm9sZSI6InVzZXIiLCJ4LWhhc3VyYS11c2VyLWlkIjoiMSIsIngtaGFzdXJhLW9yZy1pZCI6IjEifX0.ptXO8_uF4oJANmXWWm_eyxUaD4J5I8ympIZba-xVkBY";
      dio.options.headers = {"Authorization" : token, "accept": "*/*", "cache-control": "no-cache"};
      Response response = await dio.post(
        'https://535uyq7s8d.execute-api.sa-east-1.amazonaws.com/prod/$resource', 
        data: mov.toJson(),
      );
      print(response.data['id']);
       mov.id = response.data["id"];
        for (var i = 0; i < mov.movimentoItem.length; i++) {
          mov.movimentoItem[i].id = response.data["movimento_item"][i]["id"];
          mov.movimentoItem[i].idMovimento = mov.id;
        }
        for (var i = 0; i < mov.movimentoParcela.length; i++) {
          mov.movimentoParcela[i].id = response.data["movimento_parcela"][i]["id"];
          mov.movimentoParcela[i].idMovimento = mov.id;
        }
        MovimentoDAO movDao = MovimentoDAO(_hasuraBloc, _appGlobalBloc, mov);
        await movDao.insert();
        movDao = null;
      
    } catch (e) {
      print(e);
    }
  }

  @override
  void dispose() {
    stop();
  }
}
