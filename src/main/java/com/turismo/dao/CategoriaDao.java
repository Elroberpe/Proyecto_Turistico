package com.turismo.dao;

import com.turismo.conexion.ConexionDB;
import com.turismo.modelo.CategoriaPaquete;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class CategoriaDao {

	// Listar todas las categorías
	public List<CategoriaPaquete> listar() {
		List<CategoriaPaquete> lista = new ArrayList<>();

		String sql = "SELECT * FROM categorias_paquetes ORDER BY nombre";

		try (Connection con = ConexionDB.obtenerConexion();
				PreparedStatement ps = con.prepareStatement(sql);
				ResultSet rs = ps.executeQuery()) {

			while (rs.next()) {
				CategoriaPaquete categoria = new CategoriaPaquete();

				categoria.setIdCategoria(rs.getInt("id_categoria"));
				categoria.setNombre(rs.getString("nombre"));
				categoria.setDescripcion(rs.getString("descripcion"));

				lista.add(categoria);
			}

		} catch (SQLException e) {
			e.printStackTrace();
		}

		return lista;
	}

	// Buscar una categoría por ID
	public CategoriaPaquete buscarPorId(int id) {

		String sql = "SELECT * FROM categorias_paquetes WHERE id_categoria = ?";

		try (Connection con = ConexionDB.obtenerConexion(); PreparedStatement ps = con.prepareStatement(sql)) {

			ps.setInt(1, id);

			try (ResultSet rs = ps.executeQuery()) {

				if (rs.next()) {
					CategoriaPaquete categoria = new CategoriaPaquete();

					categoria.setIdCategoria(rs.getInt("id_categoria"));
					categoria.setNombre(rs.getString("nombre"));
					categoria.setDescripcion(rs.getString("descripcion"));

					return categoria;
				}
			}

		} catch (SQLException e) {
			e.printStackTrace();
		}

		return null;
	}

	// Registrar una categoría
	public boolean registrar(CategoriaPaquete categoria) {

		String sql = "INSERT INTO categorias_paquetes(nombre, descripcion) VALUES(?, ?)";

		try (Connection con = ConexionDB.obtenerConexion(); PreparedStatement ps = con.prepareStatement(sql)) {

			ps.setString(1, categoria.getNombre());
			ps.setString(2, categoria.getDescripcion());

			return ps.executeUpdate() > 0;

		} catch (SQLException e) {
			e.printStackTrace();
		}

		return false;
	}

	// Actualizar una categoría
	public boolean actualizar(CategoriaPaquete categoria) {

		String sql = "UPDATE categorias_paquetes SET nombre = ?, descripcion = ? WHERE id_categoria = ?";

		try (Connection con = ConexionDB.obtenerConexion(); PreparedStatement ps = con.prepareStatement(sql)) {

			ps.setString(1, categoria.getNombre());
			ps.setString(2, categoria.getDescripcion());
			ps.setInt(3, categoria.getIdCategoria());

			return ps.executeUpdate() > 0;

		} catch (SQLException e) {
			e.printStackTrace();
		}

		return false;
	}

	// Eliminar una categoría
	public boolean eliminar(int id) {

		String sql = "DELETE FROM categorias_paquetes WHERE id_categoria = ?";

		try (Connection con = ConexionDB.obtenerConexion(); PreparedStatement ps = con.prepareStatement(sql)) {

			ps.setInt(1, id);

			return ps.executeUpdate() > 0;

		} catch (SQLException e) {
			e.printStackTrace();
		}

		return false;
	}

}