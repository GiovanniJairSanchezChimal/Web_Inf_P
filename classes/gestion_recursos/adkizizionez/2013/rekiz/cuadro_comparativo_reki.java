/**
 * @(#)cuadro_comparativo_reki.java
 *     cuadro_comparativo_reki.jsp
 *
 * @author Israel Durán Medina.
 * @version 1.00 2012/03/13
 */
package gestion_recursos.adkizizionez.rekiz;
import comun.BD;
import java.sql.ResultSet;

public class cuadro_comparativo_reki 
{
    private String consultas;
    public int x;
    ResultSet rs,rp;
    BD MBD;
    public String productos[][];
    public String proveedores[][];
    public String cotizaciones[][];
    public int cve_registro_reki,anho_registro_reki,tot_prod,y,tot_prov,cve_provedor1,cve_provedor2,cve_cotizacion;
    public String fecha_cot1,fecha_cot2,error;
    public float prezio_kon_iva;
    
    public cuadro_comparativo_reki() 
    {
      MBD = new BD();
      consultas = "";
      x=0;
      cve_registro_reki=0;anho_registro_reki=0;tot_prod=0;y=0;tot_prov=0;cve_provedor1=0;cve_provedor2=0;prezio_kon_iva=0;
      fecha_cot1="";fecha_cot2="";error="";cve_cotizacion=0;
    }
    public void llenar_arreglos()throws Exception
    {
      consultas="SELECT COUNT(sic.rekizizionez_produktoz.cve_produkto) AS maximo "
               +"FROM sic.rekizizionez_produktoz INNER JOIN "
               +"sic.produktoz ON sic.rekizizionez_produktoz.cve_produkto = sic.produktoz.cve_produkto "
               +"WHERE (sic.rekizizionez_produktoz.cve_regiztro = "+cve_registro_reki+") AND "
               +"(sic.rekizizionez_produktoz.anio_regiztro = "+anho_registro_reki+" ) AND (sic.rekizizionez_produktoz.vigente = 1)";
      tot_prod=MBD.buscaSQL(consultas);
          
      productos=new String[4][tot_prod];
      for(x=0;x<4;x++)
      	for(y=0;y<tot_prod;y++)
      		productos[x][y]="0";
      x=0;
      consultas="SELECT sic.rekizizionez_produktoz.cve_produkto, sic.produktoz.nombre, "
      	       +"sic.rekizizionez_produktoz.unidad_medida, sic.rekizizionez_produktoz.kantidad_zolizitada_total "
               +"FROM sic.rekizizionez_produktoz INNER JOIN "
               +"sic.produktoz ON sic.rekizizionez_produktoz.cve_produkto = sic.produktoz.cve_produkto "
               +"WHERE (sic.rekizizionez_produktoz.cve_regiztro = "+cve_registro_reki+") AND "
               +"(sic.rekizizionez_produktoz.anio_regiztro = "+anho_registro_reki+") AND (sic.rekizizionez_produktoz.vigente = 1) "
               +"ORDER BY sic.produktoz.nombre ";
      for(rs=MBD.SQLBD2(consultas);rs.next();)
      {
      	productos[0][x]= String.valueOf(rs.getInt(1));
      	productos[1][x]=rs.getString(2);
      	productos[2][x]=rs.getString(3);
      	productos[3][x]=rs.getString(4);
      	x++;
      }MBD.desconectarBD();      
    
     
      x=0;
      consultas="SELECT COUNT(*) AS maximo "
               +"FROM (SELECT cve_proveedor "
               +"FROM sic.kotizazionez_provedor "
               +"WHERE (cve_produkto IN "
                    +"(SELECT cve_produkto "
                    +"FROM sic.rekizizionez_produktoz "
                    +"WHERE (cve_regiztro = "+cve_registro_reki+") AND (anio_regiztro = "+anho_registro_reki+") AND (vigente=1))) "
                    +"GROUP BY cve_proveedor) AS derivedtbl_1 ";
     tot_prov=MBD.buscaSQL(consultas);
     proveedores=new String[2][tot_prov];
        for(x=0;x<2;x++)
      	for(y=0;y<tot_prov;y++)
      		proveedores[x][y]="0";
      		
     x=0;
     consultas="SELECT sic.kotizazionez_provedor.cve_proveedor, sic.provedorez.nombre "
              +"FROM sic.kotizazionez_provedor INNER JOIN "
              +"sic.provedorez ON sic.kotizazionez_provedor.cve_proveedor = sic.provedorez.cve_proveedor "
              +"WHERE (sic.kotizazionez_provedor.cve_produkto IN "
                      +"(SELECT cve_produkto "
                      +"FROM sic.rekizizionez_produktoz "
                      +"WHERE (cve_regiztro = "+cve_registro_reki+") AND (anio_regiztro = "+anho_registro_reki+") AND (vigente=1))) "
              +"GROUP BY sic.kotizazionez_provedor.cve_proveedor, sic.provedorez.nombre "
              +"ORDER BY sic.provedorez.nombre ";
     for(rs=MBD.SQLBD2(consultas);rs.next();)
     {
        proveedores[0][x]= String.valueOf(rs.getInt(1));
      	proveedores[1][x]=rs.getString(2);
      	x++;  	
     }MBD.desconectarBD();
    
     x=0;
     cotizaciones=new String[tot_prod][tot_prov];
     for(x=0;x<tot_prod;x++)
      	for(y=0;y<tot_prov;y++)
      		cotizaciones[x][y]="0";
     
     for(x=0;x<tot_prod;x++)   
    {
    	for(y=0;y<tot_prov;y++)
    	{
    	   consultas="SELECT cve_kotizazion AS maximo "
                   +"FROM sic.rekizizionez_produktoz "
                   +"WHERE (cve_regiztro = "+cve_registro_reki+") AND (anio_regiztro = "+anho_registro_reki+") AND "
                   +"(cve_produkto = "+productos[0][x]+") AND (cve_provedor = "+proveedores[0][y]+")";	
           cve_cotizacion=MBD.buscaSQL(consultas);
           if(cve_cotizacion>0)
           {
           	   consultas="SELECT prezio_kon_iva "
                     +"FROM sic.kotizazionez_provedor "
                     +"WHERE (cve_proveedor = "+proveedores[0][y]+") AND "
                     +"(cve_produkto = "+productos[0][x]+") AND (cve_kotizazion = "+cve_cotizacion+")";
               for(rs=MBD.SQLBD2(consultas);rs.next();)
               {
               	cotizaciones[x][y]= String.valueOf(rs.getDouble(1));
               }MBD.desconectarBD();
           }
           else
           {
           	   consultas="SELECT TOP (1) prezio_kon_iva "
                        +"FROM sic.kotizazionez_provedor "
                        +"WHERE (cve_proveedor = "+proveedores[0][y]+") AND (cve_produkto = "+productos[0][x]+") "
                        +"ORDER BY fecha_regiztro DESC ";
               for(rs=MBD.SQLBD2(consultas);rs.next();)
               {
               	cotizaciones[x][y]= String.valueOf(rs.getDouble(1));
               }MBD.desconectarBD();
           }
    	}
     }    	
      
    }
    public void grabar_cuadro_comparativo()throws Exception
    {       
       consultas="DELETE FROM sic.kuadro_komparativo_reki "
                +"WHERE (cve_regiztro_reki = "+cve_registro_reki+") AND (anio_regiztro_reki = "+anho_registro_reki+")";	
       MBD.insertarSQL(consultas);
       
       llenar_arreglos();
       
       for(x=0;x<tot_prod;x++)
       {
       	  for(y=0;y<tot_prov;y++)
       	  {
       		 //if(Float.parseFloat(cotizaciones[x][y])>0)
       		 //{       		    
       		    //System.out.print(cotizaciones[x][y]);
       		 	consultas="INSERT INTO kuadro_komparativo_reki (cve_regiztro_reki, anio_regiztro_reki, cve_produkto, "
       		 		     +"cve_proveedor, fecha_regiztro, prezio_kon_iva, unidad_medida, kantidad_zolizitada_total ) "
       		 		     +"VALUES ("+cve_registro_reki+","+anho_registro_reki+","+Integer.parseInt(productos[0][x])+", "
       		 		     +" "+Integer.parseInt(proveedores[0][y])+",GETDATE(),"+Float.parseFloat(cotizaciones[x][y])+", "
       		 		     +" '"+productos[2][x]+"', "+Float.parseFloat(productos[3][x])+")";
       		 	MBD.insertarSQL(consultas);
       		 //}
          }
          //System.out.println("***");
       }
       error="CUADRO COMPARATIVO GUARDADO SATISFACTORIAMENTE.";
    }
    public void llenar_arreglos_tabla()throws Exception
    {
    	consultas="SELECT COUNT(*) AS maximo "
                 +"FROM (SELECT cve_produkto AS maximo "
                 +"FROM sic.kuadro_komparativo_reki "
                 +"WHERE (cve_regiztro_reki = "+cve_registro_reki+") AND (anio_regiztro_reki = "+anho_registro_reki+") "
                 +"GROUP BY cve_produkto) AS derivedtbl_1 ";
        tot_prod=MBD.buscaSQL(consultas);
        
        productos=new String[4][tot_prod];
        for(x=0;x<4;x++)
      	  for(y=0;y<tot_prod;y++)
      		 productos[x][y]="0";
        x=0;
        consultas="SELECT sic.kuadro_komparativo_reki.cve_produkto, sic.produktoz.nombre, unidad_medida, kantidad_zolizitada_total "
                 +"FROM sic.kuadro_komparativo_reki INNER JOIN "
                 +"sic.produktoz ON sic.kuadro_komparativo_reki.cve_produkto = sic.produktoz.cve_produkto "
                 +"WHERE (sic.kuadro_komparativo_reki.cve_regiztro_reki = "+cve_registro_reki+") AND "
                 +"(sic.kuadro_komparativo_reki.anio_regiztro_reki = "+anho_registro_reki+") "
                 +"GROUP BY sic.kuadro_komparativo_reki.cve_produkto, sic.produktoz.nombre,unidad_medida, kantidad_zolizitada_total "
                 +"ORDER BY sic.produktoz.nombre ";
        for(rs=MBD.SQLBD2(consultas);rs.next();)
        {
        	productos[0][x]= String.valueOf(rs.getInt(1));
      	    productos[1][x]=rs.getString(2);
      	    productos[2][x]=rs.getString(3);
      	    productos[3][x]=String.valueOf(rs.getDouble(4));
      	    x++;
        }MBD.desconectarBD();
        x=0;
        consultas="SELECT COUNT(*) AS maximo "
                 +"FROM (SELECT cve_proveedor "
                 +"FROM sic.kuadro_komparativo_reki "
                 +"WHERE (cve_regiztro_reki = "+cve_registro_reki+") AND (anio_regiztro_reki = "+anho_registro_reki+") "
                 +"GROUP BY cve_proveedor) AS derivedtbl_1";
        tot_prov=MBD.buscaSQL(consultas);
        
        proveedores=new String[2][tot_prov];
        for(x=0;x<2;x++)
      	  for(y=0;y<tot_prov;y++)
      		proveedores[x][y]="0";
        x=0;
        consultas="SELECT sic.kuadro_komparativo_reki.cve_proveedor, sic.provedorez.nombre "
                 +"FROM sic.kuadro_komparativo_reki INNER JOIN "
                 +"sic.provedorez ON sic.kuadro_komparativo_reki.cve_proveedor = sic.provedorez.cve_proveedor "
                 +"WHERE (sic.kuadro_komparativo_reki.cve_regiztro_reki = "+cve_registro_reki+") AND "
                 +"(sic.kuadro_komparativo_reki.anio_regiztro_reki = "+anho_registro_reki+") "
                 +"GROUP BY sic.kuadro_komparativo_reki.cve_proveedor, sic.provedorez.nombre "
                 +"ORDER BY sic.provedorez.nombre ";
        for(rs=MBD.SQLBD2(consultas);rs.next();)
        {
        	proveedores[0][x]= String.valueOf(rs.getInt(1));
      	    proveedores[1][x]=rs.getString(2);
      	    x++; 
        }MBD.desconectarBD();
        x=0;
        
        cotizaciones=new String[tot_prod][tot_prov];
        for(x=0;x<tot_prod;x++)
      	   for(y=0;y<tot_prov;y++)
      		  cotizaciones[x][y]="0";
        
        for(x=0;x<tot_prod;x++)
        {
        	for(y=0;y<tot_prov;y++)
        	{
        		consultas="SELECT prezio_kon_iva "
                         +"FROM sic.kuadro_komparativo_reki "
                         +"WHERE (cve_regiztro_reki = "+cve_registro_reki+") AND (anio_regiztro_reki = "+anho_registro_reki+") AND "
                         +"(cve_produkto = "+productos[0][x]+") AND (cve_proveedor = "+proveedores[0][y]+") ";
                for(rs=MBD.SQLBD2(consultas);rs.next();)
                {
                	cotizaciones[x][y]=String.valueOf(rs.getDouble(1));
                }MBD.desconectarBD();
        	}
        }
    }
    public void eliminar_cuadro()throws Exception
    {
    	consultas="DELETE FROM sic.kuadro_komparativo_reki "
                +"WHERE (cve_regiztro_reki = "+cve_registro_reki+") AND (anio_regiztro_reki = "+anho_registro_reki+")";	
        MBD.insertarSQL(consultas);
    }
  /*  public static void main (String[] args) throws Exception
    	{
    	    cuadro_comparativo_reki c=new cuadro_comparativo_reki();
    		c.cve_registro_reki=7;
    		c.anho_registro_reki=2012;
    		c.llenar_arreglos_tabla();
    		for(int x=0;x<4;x++)
    		{
    		
    			for(int y=0;y<c.tot_prod;y++)
    			{
    				System.out.println(c.productos[x][y]);
    			}
    			//System.out.print("\n");
    		}
    		System.out.println("---------------");		
    		for(int x=0;x<2;x++)
    		{
    		
    			for(int y=0;y<c.tot_prov;y++)
    			{
    				System.out.println(c.proveedores[x][y]);
    			}
    			//System.out.println("\n");
    		}
    		System.out.println("---------------");		
    		for(int x=0;x<c.tot_prod;x++)
    		 {
    		 	for(int y=0;y<c.tot_prov;y++)
    		 	{
    		 		 System.out.println(c.cotizaciones[x][y]);
    		 	}
      		     //System.out.println("\n");
    		 } 
      	        
    		
        }   */
  /* public static void main (String[] args) throws Exception
      	{
    		cuadro_comparativo_reki c=new cuadro_comparativo_reki();
    		c.cve_registro_reki=5;
    		c.anho_registro_reki=2011;
    		c.llenar_arreglos_tabla();
    		
    		for(c.x=0;c.x<2;c.x++)
    		{    		
      	      for(c.y=0;c.y<c.tot_prod;c.y++)
      	      {      	      
      		     System.out.print("/"+c.productos[c.x][c.y]);
      	      }
      	      System.out.println("-");
    		}
    		System.out.println("************");
    		for(c.x=0;c.x<2;c.x++)
    		{    		
      	      for(c.y=0;c.y<c.tot_prov;c.y++)
      	      {      	      
      		     System.out.print("/"+c.proveedores[c.x][c.y]);
      	      }
      	      System.out.println("-");
    		}
    		System.out.println("************");
    		for(c.x=0;c.x<c.tot_prod;c.x++)
    		{    		
      	      for(c.y=0;c.y<c.tot_prov;c.y++)
      	      {      	      
      		     System.out.print("/"+c.cotizaciones[c.x][c.y]);
      	      }
      	      System.out.println("/");
    		} 
        } */
        
}