using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using pontosDAO;

namespace Grafico
{
    public partial class Principal : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

            if (Page.IsPostBack)
            {
                if(!string.IsNullOrWhiteSpace(inputX.Text))
                {
                    NovaCoordenada();
                }
                else 
                {
                    if (!string.IsNullOrWhiteSpace(editarX.Text))
                    {
                        EditarCoordenada();
                    }
                }
            } 
            CriarHTML();
        }

        private void NovaCoordenada()
        {
            Pontos pontos = new Pontos();

            pontos.pontoX = Int32.Parse(inputX.Text);
            pontos.pontoY = Int32.Parse(inputY.Text);

            new PontosDAO().InserirPontos(pontos);

            inputX.Text = null;
            inputY.Text = null;
        }

        private void EditarCoordenada()
        {
            Pontos pontos = new PontosDAO().GetPonto(Int32.Parse(recebeId.Text));

            pontos.pontoX = Int32.Parse(editarX.Text);
            pontos.pontoY = Int32.Parse(editarY.Text);

            PontosDAO.UpdatePontos(pontos);

            editarX.Text = null;
            editarY.Text = null;
        }

        private void CriarHTML()
        {
            List<Pontos> pontos = PontosDAO.GetListPontos();

            int i = 0;
            int xConvertidoPonto = 0;
            int yConvertidoPonto = 0;
            int xConvertidoLinha = 0;
            int yConvertidoLinha = 0;

            StringBuilder sbPonto = new StringBuilder();
            StringBuilder sbLinha = new StringBuilder();
            StringBuilder sbCoordenadas = new StringBuilder();

            
            foreach (var ponto in pontos)
                {
                    xConvertidoPonto = 245 + (25 * ponto.pontoX);
                    yConvertidoPonto = (245 - 10 * i) + (-25 * ponto.pontoY);

                    sbPonto.Append($"<div id='{ponto.codigo}' role='button' class='ponto rounded-circle bg-danger' data-bs-toggle='modal' data-bs-target='#exemploModal' data-bs-codigo='{ponto.codigo}' style='position: relative; left: {xConvertidoPonto}px; top: {yConvertidoPonto}px;'></div>");

                xConvertidoLinha = 250 + (25 * ponto.pontoX);
                yConvertidoLinha = 250 + (-25 * ponto.pontoY);

                if (i == 0)
                {
                    sbCoordenadas.AppendLine($@"ctx.moveTo({xConvertidoLinha}, {yConvertidoLinha});");
                }
                else
                {
                    sbCoordenadas.AppendLine($@"ctx.lineTo({xConvertidoLinha}, {yConvertidoLinha});");
                }
                i++;
            }

            sbLinha.Append($@"<script>
                                var canvas = document.getElementById('canvas');
                                if (canvas.getContext) {{
                                    var ctx = canvas.getContext('2d');
                                    function Draw() {{

                                    ctx.beginPath();");

            sbLinha.Append(sbCoordenadas);

            sbLinha.Append($@"ctx.closePath();
				            ctx.stroke();
                        }}

                        function Color() {{
				            ctx.beginPath();");

            sbLinha.Append(sbCoordenadas);

            sbLinha.Append($@"ctx.fill();
                            }}
                        }}
                </script>");

            ltrPonto.Text = sbPonto.ToString();
            ltrLinha.Text = sbLinha.ToString();
        }
    }
}