import service.ScrapingService;
import service.ZipService;

import java.io.File;
import java.io.IOException;
import java.util.List;

public class App {
    public static void main(String args[]){
        var zipService = new ZipService();

        String url = "https://www.gov.br/ans/pt-br/acesso-a-informacao/participacao-da-sociedade/atualizacao-do-rol-de-procedimentos";
        String seletorCSS = "a[href$='.pdf']";

        List<String> hrefs = null;
        try {
            hrefs = ScrapingService.localizarLinks(url, seletorCSS);
        } catch (IOException e) {
            throw new RuntimeException(e.getMessage());
        }

        List<String> filteredHrefs = ScrapingService.filtrarLinks(hrefs);
        String pastaDestino = "anexos";
        ScrapingService.baixarAnexos(filteredHrefs, pastaDestino);

        File pastaOrigem = new File(pastaDestino);
        String arquivoDestino = "anexos_compactados.zip";

        try {
            zipService.compactarPasta(pastaOrigem, arquivoDestino);
        } catch (Exception e) {
            throw new RuntimeException(e.getMessage());
        }

        System.out.println("Arquivos baixados e compactados com sucesso!");
    }
}
