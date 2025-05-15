<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Principal.aspx.cs" Inherits="Grafico.Principal" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Projeto Grafico</title>
    <meta name="viewport" content="width=device-width, initial-scale=1" />
	<link href="bootstrap/css/bootstrap.min.css" rel="stylesheet" />
    <link href="bootstrap/css/all.min.css" rel="stylesheet"/>
	<style>
		.conteudo{
			width: 500px;
			height: 500px;
			background-color: white;
			overflow: hidden;
		}

		#graficoImagem{
			background-image: url("imagens/grafico1.png");
			background-repeat: repeat-x;
			background-size: contain;
		}

		#bordaConteudo{
			width: 550px;
			height: 550px;
			/*
			background-image: url("imagens/madeira_escura.jpg");
            background-repeat: repeat-x;
			*/
			border: solid 2px black;
			border-radius: 20px;
		}
			
		.ponto{
			width: 10px;
			height: 10px;
			position: relative;
		}
			
		#cardInput{
		position: absolute;
			left: 0px;
			top: 0px;
		}

		#gradePrincipal{
			background-image:
				repeating-linear-gradient(#000 0 2px, transparent 0px 100%), 
				repeating-linear-gradient(90deg, #000 0 2px, transparent 1px 100%);
			background-size: 250px 250px;
			/*border-bottom: solid 1.5px black;
			border-right: solid 1.5px black;*/
		}

		#gradeSecundaria{
			position: absolute;
			width: 500px;
			height: 500px;
			background-color: white;
			overflow: hidden;
			opacity: 0.3;
			border: none;
			margin: 0px;
			background-image:
				repeating-linear-gradient(#000 0 2px, transparent 0px 100%), 
				repeating-linear-gradient(90deg, #000 0 2px, transparent 1px 100%);
			background-size: 25px 25px;
		}
		canvas{
			position: absolute;
			background-color: transparent;
			border: solid 1px black;
		}

		#ferramentas{
			width: 300px;
			height: 100px;
			position: absolute;
			bottom: 0px;
			left: 0px;
		}

		.btnFerramentas{
			width: 80px;
			height: 25px;
			display: flex;
			align-items: center;
		}

		#cardBodyFerramentas{
			display: flex;
			justify-content: center;
			align-items: flex-start;
		}
	</style>
</head>
<body>
		<div id="container" class="d-flex justify-content-center my-4">
			<div id="bordaConteudo" class="d-flex justify-content-center align-items-center shadow-lg bg-secondary">	
				<div id="gradePrincipal" class="conteudo">
					<div id="gradeSecundaria" class="conteudo"></div>
					<canvas id="canvas" width="500" height="500"></canvas>
					<asp:Literal ID="ltrPonto" runat="server"></asp:Literal>
				</div>
			</div>
		</div>
		<div id="cardInput" class="card bg-secondary shadow m-2">
			<div class="card-body">
				<form  id="formTabela" runat="server" autocomplete="off">
					<div>
						<div class="input-group mb-2">
							<span class="input-group-text">X</span>
							<asp:TextBox ID="inputX" type="number" class="form-control" runat="server" ClientIDMode="Static"></asp:TextBox>
							<!--<input type="text" class="form-control" id="inputX"/>-->
						</div>

						<div class="input-group mb-2">
							<span class="input-group-text">Y</span>
							<asp:TextBox ID="inputY" type="number" class="form-control" runat="server" ClientIDMode="Static"></asp:TextBox>
							<!--<input type="text" class="form-control" id="inputY"/>-->
						</div>
						<div>
							<button class="btn btn-dark" type="submit"> Teste </button>
						</div>
					</div>
					<div class="modal fade" id="exemploModal" tabindex="-1" aria-labelledby="exemploModal" aria-hidden="true" style="display: none;">
						<div class="modal-dialog">
							<div class="modal-content">
								<div class="modal-header">
									<h1 class="modal-tittle fs-5" id="exemploModalTitulo">Editar ponto</h1>
									<button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
								</div>
								<div class="modal-body">
									<div class="mb-3 d-none">
										<label for="recebeId" class="col-form-label">Id</label>
										<asp:TextBox ID="recebeId" type="text" runat="server" class="col-form-label" ClientIDMode="static"></asp:TextBox>
									</div>
									<div class="mb-3">
										<label for="editarX" class="col-form-label">Novo valor de X:</label>
										<asp:TextBox ID="editarX" type="text" runat="server" Class="form-control" ClientIDMode="Static"></asp:TextBox>
									</div>
									<div class="mb-3">
										<label for="editarY" class="col-form-label">Novo valor de Y:</label>
										<asp:TextBox ID="editarY" type="text" runat="server" Class="form-control" ClientIDMode="Static"></asp:TextBox>
									</div>
								</div>
								<div class="modal-footer">
									<button type="button" class="btnRemover btn btn-danger" data-codigo="">Excluir</button>
									<button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancelar</button>
									<button type="submit" class="btn btn-success">Salvar</button>
								</div>
							</div>
						</div>

					</div>
				</form>
			</div>
		</div>
		<div id="ferramentas" class="card bg-secondary shadow m-2">
			<div id="cardBodyFerramentas" class="card-body">
				<button class="btn btn-light btnFerramentas m-1" onclick="Draw()">Circular</button>
				<button class="btn btn-light btnFerramentas m-1" onclick="Color()">Colorir</button>
				<button class="btn btn-light btnFerramentas m-1" onclick="teste()">Apagar</button>
			</div>
		</div>

    <script src="bootstrap/JS/all.min.js" type="text/javascript"></script>
    <script src="bootstrap/js/bootstrap.bundle.min.js" type="text/javascript"></script>
	<script src="bootstrap/JS/jquery.js"></script>
	<script>
        const exaemploModal = document.getElementById('exemploModal')
        if (exemploModal) {
            exemploModal.addEventListener('show.bs.modal', event => {
                // Button that triggered the modal
                const button = event.relatedTarget
                // Extract info from data-bs-* attributes
                const recipient = button.getAttribute('data-bs-codigo')
                // If necessary, you could initiate an Ajax request here
                // and then do the updating in a callback.

                // Update the modal's content.
                //const modalTitle = exampleModal.querySelector('.modal-title')
                const modalBodyInput = exemploModal.querySelector('.modal-body #recebeId')

                //modalTitle.textContent = `New message to ${recipient}`
				modalBodyInput.value = recipient;
            })
        }
    </script>
	<script>
		$(function () {
			$(".btnRemover").click(function () {
				if (confirm("Deseja remover esse ponto?")) {
                    let codigo = (document.getElementById('recebeId')).value;

					$.ajax({
						global: true,
						url: "Ajax.aspx/DeletarPonto",
						data: `{ codigo: ${codigo} }`,
						contentType: "application/json",
						dataType: "json",
						type: "post",
						success: function () {
							try {
								document.getElementById(`${codigo}`).remove();
							}
							finally {
								location.replace(location.pathname);
							}
						},
						error: function (err) {
							alert(`Erro ao excluir ponto: ${err}`);
						}
					})
				}
			})
		})
    </script>
	<asp:Literal ID="ltrLinha" runat="server"></asp:Literal>
	<script>
		function teste() {
			var pontos = document.getElementsByClassName('ponto');

						for (var i = 0; i < pontos.length; i++) {
							var codigoPonto = pontos[i].getAttribute("id");
								$.ajax({
									global: true,
									url: "Ajax.aspx/DeletarPonto",
									data: `{ codigo: ${codigoPonto} }`,
									contentType: "application/json",
									dataType: "json",
									type: "post",
									success: function () {
									},
									error: function (err) {
										alert(`Erro ao excluir ponto: ${err}`);
									}
								})
						}
						location.replace(location.pathname);
		}
    </script>
	<script>
            /*var canvas = document.getElementById("canvas");
            if (canvas.getContext) {
				var ctx = canvas.getContext("2d");

			function Draw() {
                ctx.beginPath();
                ctx.moveTo(200, 200);
				ctx.lineTo(300, 200);
				ctx.lineTo(300, 300);
				ctx.lineTo(200, 300);
                ctx.closePath();
				ctx.stroke();
				}

			function color() {
				ctx.beginPath();
                ctx.moveTo(200, 200);
                ctx.lineTo(300, 200);
                ctx.lineTo(300, 300);
                ctx.lineTo(200, 300);
				ctx.fill();
				}
        }*/
		

    </script>
</body>
</html>
