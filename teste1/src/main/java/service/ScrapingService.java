package service;

import org.apache.commons.io.FileUtils;
import org.jsoup.Jsoup;
import reactor.core.publisher.Flux;
import reactor.core.scheduler.Schedulers;

import java.io.*;
import java.net.URL;
import java.util.List;
import java.util.stream.Collectors;

public class ScrapingService {
    public static List<String> localizarLinks(String url, String seletorCSS) throws IOException {
        return Jsoup.connect(url)
                .get()
                .select(seletorCSS)
                .stream()
                    .map(element -> element.attr("href"))
                    .collect(Collectors.toList());
    }

    public static List<String> filtrarLinks(List<String> hrefs) {
        return hrefs.stream()
                .filter(href -> href.endsWith(".pdf"))
                .filter(href -> href.contains("Anexo"))
                .collect(Collectors.toList());
    }

    public static void baixarAnexos(List<String> hrefs, String pastaDestino){
        Flux.fromIterable(hrefs)
                .parallel()
                .runOn(Schedulers.elastic())
                .map(url -> {
                    try {
                        var urlObj = new URL(url);
                        var nomeArquivo = new File(urlObj.getPath()).getName();
                        var arquivo = new File(pastaDestino, nomeArquivo);
                        FileUtils.copyURLToFile(urlObj, arquivo);

                        System.out.println("Arquivo " + nomeArquivo + " baixado com sucesso!");
                        return url;
                    } catch (IOException e) {
                        System.err.println("Erro ao baixar o arquivo " + url + ": " + e.getMessage());
                        return null;
                    }
                })
                .sequential()
                .blockLast();
    }


}