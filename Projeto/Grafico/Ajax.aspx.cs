using pontosDAO;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Security.Cryptography.X509Certificates;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Grafico
{
    public partial class Ajax : System.Web.UI.Page
    {
        [WebMethod]
        public static void DeletarPonto(int codigo)
        {
            PontosDAO.DeletePontos(codigo);
        }
    }
}