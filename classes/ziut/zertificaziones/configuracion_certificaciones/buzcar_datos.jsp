<%@ page language="java" 
                contentType="application/json; charset=UTF-8" pageEncoding="UTF-8"
                import="java.sql.*,java.lang.*,java.util.*, comun.*, certificacion_ciut.*" errorPage="../../error.jsp" 
                import="org.json.simple.JSONObject"
%>
<%
int accion=0;
String mensaje = String.valueOf(session.getAttribute("usuario"));
try
{		
		CIUT_certificacion ce=new CIUT_certificacion();
		accion=Integer.parseInt(request.getParameter("p_accion"));
		
		JSONObject json = new JSONObject();
		
		if(accion==1)
		{
			ce.cve_certificacion=Integer.parseInt(request.getParameter("p_cve_certificacion"));
			ce.obtener_datos_certificacion();														
					
			json.put("cve_certificacion", ce.cve_certificacion);
			json.put("nombre_certificacion", ce.nombre_certificacion);
			json.put("precio", ce.precio);
			json.put("fecha_ins_inicio", ce.fecha_ins_inicio);
			json.put("fecha_ins_fin", ce.fecha_ins_fin);
			json.put("fecha_entrega_ficha", ce.fecha_entrega_ficha);
			json.put("fecha_examen", ce.fecha_examen);
			json.put("cve_pago", ce.cve_pago);
		}else{
			ce.cve_pago=Integer.parseInt(request.getParameter("p_cve_pago"));
			ce.buscar_concepto();
			json.put("precio", ce.precio);
		}	
		out.print(json); 
 		out.flush(); 
}
catch (Exception exc)
{
	out.println("Revisa tu error--> "+exc);
}
%>
