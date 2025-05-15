using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace pontosDAO
{
    public class PontosDAO
    {
        public static string GetConnectionString()
        {
            string conn = string.Format("server = {0}; uid = {1}; pwd = {2}; database = {3}; connect timeout = 10",
                @"MA294\SQLEXPRESS", "sa", "Micro!7958", "BancoGrafico");
            return conn;
        }

        public Pontos GetPonto(int codigo)
        {
            Pontos ponto = new Pontos();
            string sql = "SELECT * FROM tbPontos WHERE codigo = @codigo";

            using (SqlConnection conn = new SqlConnection(GetConnectionString())){
                using (SqlCommand command = new SqlCommand())
                {
                    command.Connection = conn;
                    command.CommandText = sql;
                    command.Parameters.AddWithValue("@codigo", codigo);

                    conn.Open();
                    using (SqlDataReader reader = command.ExecuteReader())
                    {
                        reader.Read();
                        ponto = Db2Pontos(reader);
                    }

                }
                return ponto;
            }

        }

        public static List<Pontos> GetListPontos()
        {
            List<Pontos> pontos = new List<Pontos>();
            string sql = "SELECT * FROM tbPontos";

            using (SqlConnection conn = new SqlConnection(GetConnectionString()))
            {
                using (SqlCommand command = new SqlCommand())
                {
                    command.Connection = conn;
                    command.CommandText = sql;

                    conn.Open();
                    using (SqlDataReader reader = command.ExecuteReader())
                    {
                        while (reader.Read())
                        {
                            pontos.Add(Db2Pontos(reader));
                        }
                    }
                }
            }
            return pontos;
        }

        public int InserirPontos(Pontos pontos)
        {
            int codigo = 0;
            string sql = "insert into tbPontos (pontoX, pontoY) OUTPUT Inserted.Codigo VALUES (@pontoX, @pontoY)";

            using (SqlConnection conn = new SqlConnection(GetConnectionString()))
            {
                using (SqlCommand command = new SqlCommand())
                {
                    command.Connection = conn;
                    command.CommandText = sql;
                    command.Parameters.AddWithValue("@pontoX", pontos.pontoX);
                    command.Parameters.AddWithValue("@pontoY", pontos.pontoY);

                    conn.Open();
                    codigo = (int)command.ExecuteScalar();
                    pontos.codigo = codigo;
                }
            }

            return codigo;
        }

        public static void UpdatePontos(Pontos pontos)
        {
            string sql = "UPDATE tbPontos SET pontoX = @pontoX, pontoY = @pontoY WHERE codigo = @codigo";

            using (SqlConnection conn = new SqlConnection(GetConnectionString()))
            {
                using (SqlCommand command = new SqlCommand())
                {
                    command.Connection = conn;
                    command.CommandText = sql;
                    command.Parameters.AddWithValue("@pontoX", pontos.pontoX);
                    command.Parameters.AddWithValue("@pontoY", pontos.pontoY);
                    command.Parameters.AddWithValue("@codigo", pontos.codigo);

                    conn.Open();
                    command.ExecuteNonQuery();
                    conn.Close();
                }
            }
        }
        public static void DeletePontos(int codigo)
        {
            string sql = "DELETE FROM tbPontos WHERE codigo = @codigo";

            using(SqlConnection conn = new SqlConnection(GetConnectionString()))
            {
                using(SqlCommand command = new SqlCommand())
                {
                    command.Connection = conn;
                    command.CommandText = sql;
                    command.Parameters.AddWithValue("@codigo", codigo);

                    conn.Open();
                    command.ExecuteNonQuery();
                    conn.Close();
                }
            }
        }

        private static Pontos Db2Pontos(SqlDataReader reader)
        {
            return new Pontos()
            {
                codigo = (int)reader["codigo"],
                pontoX = (int)reader["pontoX"],
                pontoY = (int)reader["pontoY"]
            };
        }
    }
}
