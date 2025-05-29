using System.Collections.Generic;
using System.Linq;
using System.Web.Http.Cors;
using CineClub_TuPeliculaAPI.Models;

namespace CineClub_TuPeliculaAPI.Clases
    {
    [EnableCors(origins: "http://localhost:60135", headers: "*", methods: "*")]
    public class ClsOpeCargo
        {
        // Contexto de la base de datos
        private BD_CineClub_TuPeliculaEntities db = new BD_CineClub_TuPeliculaEntities( );


        // Listar todos los cargos
        public List<cargo> ListarCargos ()
            {
            return db.cargo.OrderBy(x => x.descripcion).ToList( );
            }

        // Buscar un cargo por ID
        public cargo ObtenerCargoPorId (int id)
            {
            return db.cargo.FirstOrDefault(x => x.id_cargo == id);
            }

        // Agregar un nuevo cargo
        public bool AgregarCargo (string descripcion)
            {
            try
                {
                var nuevoCargo = new cargo
                    {
                    descripcion = descripcion
                    };
                db.cargo.Add(nuevoCargo);
                db.SaveChanges( );
                return true;
                }
            catch
                {
                return false;
                }
            }

        // Actualizar un cargo existente
        public bool ActualizarCargo (int id, string nuevaDescripcion)
            {
            try
                {
                var cargoExistente = db.cargo.FirstOrDefault(x => x.id_cargo == id);
                if (cargoExistente == null)
                    return false;

                cargoExistente.descripcion = nuevaDescripcion;
                db.SaveChanges( );
                return true;
                }
            catch
                {
                return false;
                }
            }

        // Eliminar un cargo
        public bool EliminarCargo (int id)
            {
            try
                {
                var cargoEliminar = db.cargo.FirstOrDefault(x => x.id_cargo == id);
                if (cargoEliminar == null)
                    return false;

                db.cargo.Remove(cargoEliminar);
                db.SaveChanges( );
                return true;
                }
            catch
                {
                return false;
                }
            }
        }
    }
